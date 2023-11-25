const { Readability } = require('@mozilla/readability')
const { JSDOM } = require('jsdom')
const { writeData } = require('./utils')

const main = async () => {
  const url = 'https://www.watch.impress.co.jp/docs/topic/1520290.html'
  const response = await fetch(url)
  const text = await response.text()

  const doc = new JSDOM(text, { url })
  const reader = new Readability(doc.window.document)
  const article = reader.parse()
  const articleText = article.textContent

  const chunkedTexts = articleText
    .split(/。/)
    .map(t => t.trim())
    .filter(t => t.length > 0)
    .map(t => t + '。')

  writeData('article_all.txt', chunkedTexts.join('\n'))
  writeData('article.txt', chunkedTexts.slice(0, 12).join('\n'))
}

main()
  .then(() => console.log('Done'))
  .catch(console.error)
