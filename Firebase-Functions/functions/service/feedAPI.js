import { Readability } from '@mozilla/readability'
import { logger } from 'firebase-functions/v1';
import { JSDOM } from 'jsdom'
import fetch from 'node-fetch'
import { convertURL } from '../util.js';

/**
 * RSS URL 배열에 있는 내용들을 비동기적으로 json으로 파싱한다.
 * @param {Array<string>} urls RSS URL
 * @returns 
 */
export async function fetchParsedRSSList(urls) {
  return await Promise.all(urls.map(async (url) => await fetchParsedRSS(url)))
}

/**
 * RSS URL에 있는 내용을 json으로 파싱한다.
 * @param {string} rssURL 블로그 RSS URL
 * @returns 
 */
export async function fetchParsedRSS(rssURL) {
  const urlComponent = encodeURIComponent(rssURL)

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

export async function getBlogTitle(blogURL) {
  const rssURL = convertURL(blogURL)
	const rss = await fetchParsedRSS(rssURL)
  return rss.feed.title
}

/**
 * 읽기모드로 변환된 html을 가져온다.
 * 모바일 호환을 위해 code block내부의 줄바꿈과 탭을 html 태그로 변환한다.
 * @param {String} url 
 * @returns 
 */
export async function fetchContent(url) {
    const html = await fetchHTML(url)
    const document = new JSDOM(html).window.document
    const thumbnailURL = getThumnailURL(document)
    const compatibleDocument = makeCompatibleWithMobile(document)
    const readableDocument = makeReadable(compatibleDocument)

    return {
      content: readableDocument, 
      thumbnailURL: thumbnailURL
    }
}

/**
 * url을 받아 html String을 리턴함
 * 가져오면서 에러 발생시 빈 값 리턴
 * @param {String} url 
 * @returns {String}
 */

async function fetchHTML(url) {
  try {
    const response = await fetch(url)
    const html = await response.text()
    return html
  } catch {
    logger.log("html을 가져오는 중 에러 발생")
    return ""
  }
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
  if (codeTags != null) {
    codeTags.forEach(code => {
      code.innerHTML = code.innerHTML.replace(/\n/g, "<br />")
      code.innerHTML = code.innerHTML.replace(/    /g, "\&emsp\;")
    })
  }
  return dom
}

 /**
  * html 에서 썸네일이미지를 파싱해 가져옴
 * @param {document} JSDOMD.document 
 * @returns {String} thumbnailURL
 */

 function getThumnailURL(document) {
  const thumnailURL = document.head.querySelector(`[property~="og:image"][content]`).content
  const tistoryDefaultImage = "https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Ftistory_admin%2Fstatic%2Fimages%2FopenGraph%2Fopengraph.png"
  if (thumnailURL == tistoryDefaultImage ) {
    return ""
  }
  return thumnailURL
}
