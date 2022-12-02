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