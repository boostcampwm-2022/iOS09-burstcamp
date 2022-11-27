import { Readability } from '@mozilla/readability'
import { JSDOM } from 'jsdom'
import fetch from 'node-fetch'

/**
 * RSS URL 배열에 있는 내용들을 비동기적으로 json으로 파싱한다.
 * @param {Array<string>} urls RSS URL
 * @returns 
 */
export async function fetchParsedRSSList(urls) {
  return await Promise.all(urls.map(async (url) => await fetchParsedRSS(url)));
}

/**
 * RSS URL에 있는 내용을 json으로 파싱한다.
 * @param {string} rssURL 블로그 RSS URL
 * @returns 
 */
async function fetchParsedRSS(rssURL) {
  const urlComponent = encodeURIComponent(rssURL);

  const requestURL = `https://api.rss2json.com/v1/api.json?rss_url=${urlComponent}`
  const options = {
    method: "POST",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json;charset=UTF-8",
    }
  }

  const result = await fetch(requestURL, options)

  return result.json()
}

/**
 * 읽기모드로 변환된 html을 가져온다.
 * 모바일 호환을 위해 code block내부의 줄바꿈과 탭을 html 태그로 변환한다.
 * @param {String} url 
 * @returns 
 */
export async function fetchContent(url) {
  const response = await fetch(url)
  const html = await response.text()
  const document = new JSDOM(html).window.document
  const compatibleDocument = makeCompatibleWithMobile(document)
  const readableDocument = makeReadable(compatibleDocument)
  return readableDocument
}

/**
 * html을 읽기모드로 바꿔준다.
 * @param {Document} dom 
 * @returns {String}
 */
function makeReadable(dom) {
  const reader = new Readability(dom)
  const content = reader.parse().content;
  return content
}

/**
 * Firestore에 저장된 html을 WKWebView에서 예쁘게 보여주기 위해
 * code block의 줄바꿈과 탭을 html 태그로 변환한다.
 * @param {Document} dom 
 * @returns {Document}
 */
function makeCompatibleWithMobile(dom) {
  const codeTags = dom.querySelectorAll('code')
  codeTags.forEach(code => {
    code.innerHTML = code.innerHTML.replace(/\n/g, "<br />");
    code.innerHTML = code.innerHTML.replace(/    /g, "\&emsp\;");
  })
  return dom
}