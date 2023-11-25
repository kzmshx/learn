const Mustache = require('mustache')
const { readData, readTemplate, writeData, sleep, createOpenAIClient } = require('./utils')

const openai = createOpenAIClient()

const main = async () => {
  const articleAll = readData('article_all.txt')
  const articleLines = articleAll.split('\n')
  const chunkedArticleLines = articleLines.reduce(
    (acc, line) => {
      if (acc[acc.length - 1].join('').length < 2000) {
        acc[acc.length - 1].push(line)
      } else {
        acc.push([line])
      }
      return acc
    },
    [[]],
  )

  const promptTemplate = readTemplate('extract_ruby.txt')

  const ssmlLines = []
  for (const lines of chunkedArticleLines.slice(0, 10)) {
    const prompt = Mustache.render(promptTemplate, { input: lines.join('\n') })

    const response = await openai.createChatCompletion({
      model: 'gpt-3.5-turbo',
      messages: [{ role: 'user', content: prompt }],
      temperature: 0,
    })

    const message = response.data.choices[0].message
    const content = message.content
    const map = JSON.parse(content)
    const mapItems = Object.entries(map)
      .filter(([k, v]) => k !== v)
      .sort((a, b) => a[0].length - b[0].length)

    ssmlLines.push(
      ...lines
        .map(l => mapItems.reduce((a, [k, v]) => a.replace(k, `<phoneme type="ruby" ph="${v}">${k}</phoneme>`), l))
        .map(l => `<speak>${l}</speak>`),
    )

    await sleep(1)
  }

  writeData('article_ssml.txt', ssmlLines.join('\n'))
}

main()
