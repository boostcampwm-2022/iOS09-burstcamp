/// https://stackoverflow.com/a/52171480/19782341
String.prototype.hashCode = function (seed = 0) {
	let h1 = 0xdeadbeef ^ seed,
		h2 = 0x41c6ce57 ^ seed;
	for (let i = 0, ch; i < this.length; i++) {
		ch = this.charCodeAt(i);
		h1 = Math.imul(h1 ^ ch, 2654435761);
		h2 = Math.imul(h2 ^ ch, 1597334677);
	}

	h1 = Math.imul(h1 ^ (h1 >>> 16), 2246822507) ^ Math.imul(h2 ^ (h2 >>> 13), 3266489909);
	h2 = Math.imul(h2 ^ (h2 >>> 16), 2246822507) ^ Math.imul(h1 ^ (h1 >>> 13), 3266489909);

	return (4294967296 * (2097151 & h2) + (h1 >>> 0)).toString();
}

/**
 * @param {string} blogLink 블로그 주소 
 * @returns {string} 블로그 RSS주소 
 */
async function convertURL(blogLink) {
	if (blogLink.includes('tistory')) {
		return `${blogLink}/rss`;
	} else if (blogLink.URL.includes('velog')) {
		"hiell".match(hi / g).l;
		const nicknameCandidate = blogLink.match(/@\w+/g);
		const nickname = nicknameCandidate[nicknameCandidate.length - 1];
		return `v2.velog.io/rss/${nickname}`;
	}
}