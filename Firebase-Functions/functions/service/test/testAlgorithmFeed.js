import { logger } from "firebase-functions/v1";
import { fetchContent } from "../feedAPI.js";
import { isSolvingAlgorithm, isContainBaekJoonLink } from "../../util.js";

export async function testIsAlgorithmFeed() {

  const mockUpURL = [
    {
      blogTitle : "크기가 큰 배열에서의 탐색 &amp; 캐시 히트",
      blogURL :  "https://minios.tistory.com/75"
    },
    {
      blogTitle : "[백준] 18258 큐 2 - Swift",
      blogURL :  "https://minios.tistory.com/55"
    },
    {
      blogTitle : "[실험실] - JPEG 압축률에 따른 품질 비교 (10% ~ 100%)",
      blogURL :  "https://malchafrappuccino.tistory.com/144"
    }
  ]

  mockUpURL.forEach( (feed) => {
    checkIsAlgorithm(feed.blogTitle, feed.blogURL)
  })
}

async function checkIsAlgorithm(title, blogURL) {
  const feedInfo = await fetchContent(blogURL)
	const content = feedInfo.content
  let titleResult = isSolvingAlgorithm(title)
  let contentResult = isContainBaekJoonLink(content)
  logger.log(title, "결과 - 제목에 포함", titleResult, "내용에 링크 포함",contentResult)
}