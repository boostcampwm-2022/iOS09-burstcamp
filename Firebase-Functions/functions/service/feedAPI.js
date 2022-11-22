import axios from 'axios';

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

  const result = await axios.get(
    `https://api.rss2json.com/v1/api.json?rss_url=${urlComponent}`
  );

  return result.data;
}