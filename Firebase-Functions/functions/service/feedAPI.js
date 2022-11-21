import axios from 'axios';

/**
 * 
 * @param {Array<string>} links RSSLink
 * @returns 
 */
export async function getBlogsByRSSLinkList(links) {
  return await Promise.all(links.map(async (link) => await fetchBlogRSS(link)));
}

/**
 * 
 * @param {string} rssLink 블로그 RSS Link
 * @returns 
 */
async function fetchBlogRSS(rssLink) {
  const urlComponent = encodeURIComponent(rssLink);

  const result = await axios.get(
    `https://api.rss2json.com/v1/api.json?rss_url=${urlComponent}`
  );

  return result.data;
}