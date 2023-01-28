import { logger } from "firebase-functions/v1";
import { fetchContent, fetchParsedRSS } from "../feedAPI.js";


export async function testYouTakBlog() {
  const blogURL = "https://malchafrappuccino.tistory.com/"
  await testUpdateRSS(blogURL)
}

async function testUpdateRSS(blogURL) {
  const feedInfo = await fetchContent("https://malchafrappuccino.tistory.com/148")
  logger.log(feedInfo.content)``
  logger.log(feedInfo.thumbnailURL)
}
