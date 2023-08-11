const { Readability } = require('@mozilla/readability')
const { JSDOM } = require('jsdom')
const fs = require('fs')
const path = require('path')

const dataDir = path.join(__dirname, '../data')

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

  fs.writeFileSync(path.join(dataDir, 'article_all.txt'), chunkedTexts.join('\n'))
  fs.writeFileSync(path.join(dataDir, 'article.txt'), chunkedTexts.slice(0, 12).join('\n'))
}

main()
  .then(() => console.log('Done'))
  .catch(console.error)
