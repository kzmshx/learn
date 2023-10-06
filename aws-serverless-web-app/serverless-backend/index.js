const randomBytes = require('crypto').randomBytes
const aws = require('aws-sdk')

const dynamodb = new aws.DynamoDB.DocumentClient()

const unicorns = [
  { Name: 'Bucephalus', Color: 'Golden', Gender: 'Male' },
  { Name: 'Shadowfax', Color: 'White', Gender: 'Male' },
  { Name: 'Rocinante', Color: 'Yellow', Gender: 'Female' },
]

const errorResponse = (message, awsRequestId, callback) => {
  callback(null, {
    statusCode: 500,
    body: JSON.stringify({
      Error: message,
      Reference: awsRequestId,
    }),
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  })
}

const toUrlString = buffer => {
  return buffer.toString('base64').replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '')
}

const findUnicorn = pickupLocation => {
  console.log(`Finding unicorn for (${pickupLocation.Latitude}, ${pickupLocation.Longitude})`)
  return unicorns[Math.floor(Math.random() * unicorns.length)]
}

const saveRide = (rideId, username, unicorn) => {
  return dynamodb
    .put({
      TableName: 'Rydes',
      Item: {
        RideId: rideId,
        User: username,
        Unicorn: unicorn,
        RequestTime: new Date().toISOString(),
      },
    })
    .promise()
}

exports.handler = (event, context, callback) => {
  if (!event.requestContext.authorizer) {
    errorResponse('Authorization not configured', context.awsRequestId, callback)
    return
  }

  const rideId = toUrlString(randomBytes(16))

  console.log(`Received event (${rideId}): ${event}`)

  const username = event.requestContext.authorizer.claims['cognito:username']

  const requestBody = JSON.parse(event.body)
  const pickupLocation = requestBody.PickupLocation
  const unicorn = findUnicorn(pickupLocation)

  saveRide(rideId, username, unicorn)
    .then(() => {
      callback(null, {
        statusCode: 201,
        body: JSON.stringify({
          RideId: rideId,
          Unicorn: unicorn,
          Eta: '30 seconds',
          Rider: username,
        }),
        headers: {
          'Access-Control-Allow-Origin': '*',
        },
      })
    })
    .catch(err => {
      console.error(err)
      errorResponse(err.message, context.awsRequestId, callback)
    })
}
