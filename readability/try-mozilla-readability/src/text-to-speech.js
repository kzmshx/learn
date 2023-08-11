const { PollyClient, SynthesizeSpeechCommand } = require('@aws-sdk/client-polly')
const fs = require('fs')
const path = require('path')

const dataDir = path.join(__dirname, '../data')

const polly = new PollyClient({ region: 'ap-northeast-1' })

const main = async () => {
  const articleLines = fs.readFileSync(path.join(dataDir, 'article.txt'), 'utf-8').trim().split('\n')

  for (const [i, text] of Object.entries(articleLines)) {
    const command = new SynthesizeSpeechCommand({
      LanguageCode: 'ja-JP',
      OutputFormat: 'mp3',
      Text: text,
      TextType: 'text',
      VoiceId: 'Mizuki',
    })
    const output = await polly.send(command)
    const audioBytes = await output.AudioStream.transformToByteArray()
    const audioBuf = Buffer.from(audioBytes)

    fs.writeFileSync(path.join(dataDir, `speech_${i}.mp3`), audioBuf)
  }

  const articleRubyLines = fs.readFileSync(path.join(dataDir, 'article_ruby.txt'), 'utf-8').trim().split('\n')

  for (const [i, rubyText] of Object.entries(articleRubyLines)) {
    const command = new SynthesizeSpeechCommand({
      LanguageCode: 'ja-JP',
      OutputFormat: 'mp3',
      Text: rubyText,
      TextType: 'text',
      VoiceId: 'Mizuki',
    })
    const output = await polly.send(command)
    const audioBytes = await output.AudioStream.transformToByteArray()
    const audioBuf = Buffer.from(audioBytes)

    fs.writeFileSync(path.join(dataDir, `speech_ruby_${i}.mp3`), audioBuf)
  }

  const articleSsmlLines = fs.readFileSync(path.join(dataDir, 'article_ssml.txt'), 'utf-8').trim().split('\n')

  for (const [i, ssmlText] of Object.entries(articleSsmlLines)) {
    const command = new SynthesizeSpeechCommand({
      LanguageCode: 'ja-JP',
      OutputFormat: 'mp3',
      Text: ssmlText,
      TextType: 'ssml',
      VoiceId: 'Mizuki',
    })
    const output = await polly.send(command)
    const audioBytes = await output.AudioStream.transformToByteArray()
    const audioBuf = Buffer.from(audioBytes)

    fs.writeFileSync(path.join(dataDir, `speech_ssml_${i}.mp3`), audioBuf)
  }
}

main()
  .then(() => console.log('Done'))
  .catch(console.error)
