const fs = require('fs')
const path = require('path')
const { Configuration, OpenAIApi } = require('openai')
const { PollyClient } = require('@aws-sdk/client-polly')

const dataDir = path.join(__dirname, '../data')

const templateDir = path.join(__dirname, 'templates')

const readData = relativePath => {
  return fs.readFileSync(path.join(dataDir, relativePath)).toString()
}

const readTemplate = relativePath => {
  return fs.readFileSync(path.join(templateDir, relativePath)).toString()
}

const writeData = (relativePath, data) => {
  fs.writeFileSync(path.join(dataDir, relativePath), data)
}

const sleep = async second => new Promise(resolve => setTimeout(resolve, second * 1000))

const createOpenAIClient = () => {
  const configuration = new Configuration({
    organization: process.env.OPENAI_ORGANIZATION_ID,
    apiKey: process.env.OPENAI_API_KEY,
  })
  return new OpenAIApi(configuration)
}

const createPollyClient = () => {
  return new PollyClient({ region: 'ap-northeast-1' })
}

module.exports = {
  dataDir,
  templateDir,
  readData,
  readTemplate,
  writeData,
  sleep,
  createOpenAIClient,
  createPollyClient,
}
