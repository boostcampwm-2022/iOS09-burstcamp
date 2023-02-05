import MD5 from 'crypto-js/md5.js'

/// https://stackoverflow.com/a/52171480/19782341
String.prototype.hashCode = function() {
	return MD5(this).toString()
}

/**
 * @param {string} blogURL 블로그 주소 
 * @returns {string} 블로그 RSS주소 
 */
export function convertURL(blogURL) {
	if (blogURL.includes('tistory')) {
		return `${blogURL}/rss`
	} else if (blogURL.includes('velog')) {
		const nicknameCandidate = blogURL.match(/@[\w-]+/g)
		const nickname = nicknameCandidate[nicknameCandidate.length - 1]
		return `v2.velog.io/rss/${nickname}`
	}
}

 /**
  * 제목에 백준, 프로그래머스 들어가 false
 * @param {String} feed.title
 * @returns {Bool} 
 */

 export function isSolvingAlgorithm(title) {
  let algorithmSite = ["백준", "프로그래머스"]
  for (let i = 0; i < algorithmSite.length; i++) {
    if (title.includes(algorithmSite[i])) { return true }
  }
  return false
}

 /**
  * html 내용에 백준 링크가 있다면 false 
 * @param {String} html
 * @returns {Bool} 
 */

 export function isContainBaekJoonLink(feedContent) {
  let baekJoonLink = "https://www.acmicpc.net/"
  return feedContent.includes(baekJoonLink) ? true : false
}
