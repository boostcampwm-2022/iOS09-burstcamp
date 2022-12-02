import { MD5 } from 'crypto-js'

/// https://stackoverflow.com/a/52171480/19782341
String.prototype.hashCode = function() {
	const a = MD5(this).toString()
}

/**
 * @param {string} blogLink 블로그 주소 
 * @returns {string} 블로그 RSS주소 
 */
export async function convertURL(blogLink) {
	if (blogLink.includes('tistory')) {
		return `${blogLink}/rss`
	} else if (blogLink.includes('velog')) {
		const nicknameCandidate = blogLink.match(/@[\w-]+/g)
		const nickname = nicknameCandidate[nicknameCandidate.length - 1]
		return `v2.velog.io/rss/${nickname}`
	}
}