const { Readability } = require('@mozilla/readability')
const { JSDOM } = require('jsdom')

const buildUrl = (baseUrl, path, queries) => {
  const url = baseUrl.replace(/\/$/, '') + '/' + path.replace(/^\//, '')
  const query = Object.entries(queries)
    .map(([k, v]) => `${k}=${encodeURIComponent(v)}`)
    .join('&')
  return query ? `${url}?${query}` : url
}

const main = async () => {
  const url = 'https://www.watch.impress.co.jp/docs/topic/1520290.html'
  const response = await fetch(url)
  const text = await response.text()

  console.log([text.slice(0, 1000), text.length])

  const doc = new JSDOM(text, { url })
  const reader = new Readability(doc.window.document)
  const article = reader.parse()
  const articleContent = article.content
  const articleText = article.textContent

  console.log([articleContent.slice(0, 1000), articleContent.length])
  console.log([articleText.slice(0, 1000), articleText.length])
}

main()
