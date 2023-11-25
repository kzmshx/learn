const fs = require('fs')
const path = require('path')
const { SynthesizeSpeechCommand } = require('@aws-sdk/client-polly')
const { dataDir, readData, writeData, createPollyClient } = require('./utils')

const polly = createPollyClient()

const main = async () => {
  const ssmlLines = readData('article_all_ssml.txt').trim().split('\n')
  for (const [i, line] of Object.entries(ssmlLines)) {
    const dest = `speech_ssml_${i.toString().padStart(4, '0')}.mp3`
    console.log(dest)

    if (fs.existsSync(path.join(dataDir, dest))) {
      continue
    }

    const command = new SynthesizeSpeechCommand({
      LanguageCode: 'ja-JP',
      OutputFormat: 'mp3',
      Text: line,
      TextType: 'ssml',
      VoiceId: 'Mizuki',
    })
    const output = await polly.send(command)
    const audioBytes = await output.AudioStream.transformToByteArray()
    const audioBuf = Buffer.from(audioBytes)

    writeData(dest, audioBuf)
  }
}

main()
  .then(() => console.log('Done'))
  .catch(console.error)
