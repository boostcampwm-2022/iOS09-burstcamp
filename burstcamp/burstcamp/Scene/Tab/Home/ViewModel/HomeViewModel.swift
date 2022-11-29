//
//  HomeViewModel.swift
//  Eoljuga
//
//  Created by youtak on 2022/11/21.
//

import Foundation

final class HomeViewModel {
    var normalFeedData: [Feed] = []

    init() {
        normalFeedData = fetchMockUpFeeds()
    }
}

extension HomeViewModel {
    private func fetchMockUpFeeds() -> [Feed] {
        let pubDate = pubDate()
        var result: [Feed] = []
        let feed = fetchMockUpFeed(pubDate: pubDate)
        for _ in 0..<20 {
            result.append(feed)
        }
        return result
    }

    private func fetchMockUpFeed(pubDate: Date) -> Feed {
        return Feed(
            feedUUID: "",
            writerUUID: "",
            feedTitle: "",
            pubDate: pubDate,
            url: "https://luen.tistory.com/202",
            thumbnailURL: #"https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2Fvf7iP%2FbtrDThPQ5c9%2FeFXjFTQJwPVL71pbFJvl9K%2Fimg.png"#,
            content: #"<p data-ke-size="size16">4월에 퇴사를 하고 올해 목표중 하나였던 부스트캠프를 합격해서 후기를 끄적여보려고 합니다..</p> <figure contenteditable="false" data-ke-type="emoticon" data-ke-align="alignLeft" data-emoticon-type="niniz" data-emoticon-name="023" data-emoticon-isanimation="false" data-emoticon-src="https://t1.daumcdn.net/keditor/emoticon/niniz/large/023.gif"><img src="https://t1.daumcdn.net/keditor/emoticon/niniz/large/023.gif" width="150" /></figure> <p><figure class='imageblock alignLeft' data-origin-width='1208' data-origin-height='194' data-ke-mobilestyle='alignCenter'><span data-url='https://blog.kakaocdn.net/dn/cCNUO8/btrHdaInRA4/rvGLLlOBTqAk2kfKhHIenK/img.png' data-lightbox='lightbox' data-alt=''><img src='https://blog.kakaocdn.net/dn/cCNUO8/btrHdaInRA4/rvGLLlOBTqAk2kfKhHIenK/img.png' srcset='https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcCNUO8%2FbtrHdaInRA4%2FrvGLLlOBTqAk2kfKhHIenK%2Fimg.png' width='536' height='86' data-ke-mobilestyle='alignCenter'/></span></figure></p> <p data-ke-size="size16">&nbsp;</p> <h2 data-ke-size="size26"><b>부스트캠프 지원한 이유</b></h2> <p data-ke-size="size16">iOS 과정의 부트캠프는 많지 않고 (있어도 유료가 많은편) 부캠의 커리큘럼을 보고 실력을 향상하는데 많은 도움이 될 것 같아서 작년부터 너무너무 하고싶었습니다 ㅎ.ㅎ</p> <p data-ke-size="size16">작년에는 코테 준비도 뭐고 아무것도 안하고 봤더니 코테 1차 탈락..</p> <p data-ke-size="size16">올해에는 알고리즘 문제를 꾸준히는 아니지만 손에 놓지는 않고 계속 푼 결과 합격..! 갬동 ㅠ_ㅠ</p> <p data-ke-size="size16">&nbsp;</p> <h2 data-ke-size="size26"><b>자기소개서</b></h2> <p data-ke-size="size16">최대한 iOS 개발이 너무 하고 싶은 것처럼 보이게, 그리고 부스트캠프가 왜 하고싶은지 생각하면서 적었습니다.</p> <p data-ke-size="size16">적은 내용은 개인플젝 + 팀플젝 했을 때 경험으로 [iOS 개발에 관심많아요!!!] 라고 적었지만 굳이 관련 경험으로 적지 않아도 무관한 것 같습니다 ㅎ.ㅎ&nbsp;</p> <p data-ke-size="size16">&nbsp;</p> <h2 data-ke-size="size26"><b>1차 코딩테스트</b></h2> <p data-ke-size="size16">CS문제가 공부를 안했다면 여러개를 고르라는 점에서 생각보다 시간이 오래 걸립니다.</p> <p data-ke-size="size16">부스트코스의 CS50 강의를 듣거나 퀴즈를 풀어보는 것을 추천드립니다.</p> <p data-ke-size="size16">그리고 자가진단 문제도! (친구는 시험 전날에 자가진단 수강신청이 안돼서 보내줬습니다 ㅋㅋ)</p> <p data-ke-size="size16">&nbsp;</p> <p data-ke-size="size16">코테는 Swift 언어로 봤습니다.</p> <p data-ke-size="size16">사실 문제가 잘 기억나지는 않는데 1번과 2번 모두 구현능력을 요구하는 문제 같았습니다.</p> <p data-ke-size="size16">1번을 다 풀고 2번은 테스트케이스 중 몇개만 맞춰서 1.5솔로 마무리 했습니다.</p> <p data-ke-size="size16">2번은 복잡한 비트문제로 나름 풀만했지만 이보다 더한게 2차 코딩테스트였습니다.</p> <p data-ke-size="size16">&nbsp;</p> <h2 data-ke-size="size26"><b>2차 코딩테스트</b></h2> <p data-ke-size="size16">2차 코딩테스트는 3문제가 주어졌습니다.</p> <p data-ke-size="size16">1번은 개인적으로 1차 코딩테스트보다 쉬웠고 (근데 예외처리 안해서 테케 몇개 틀렸을게 분명.........)</p> <p data-ke-size="size16">2, 3번은... 무엇보다 개인적으로지만 여태 봤던 코테 중에 제일 시간이 오래 걸릴만한 문제였습니다. 3시간을 왜 주나 했더니..!</p> <p data-ke-size="size16">그래도 시간을 많이줘서 꾸역꾸역 2번을 구현하고 봤더니 3번을 푸려면 설계를 다시 해야할 것 같더라구요..</p> <p data-ke-size="size16">너무 앞만보고 구현하지 말고 넓게 봤으면 됐을텐데 아쉬웠습니다..</p> <p data-ke-size="size16">주어진 테케로만은 2솔이지만 1번 예외처리를 시험이 끝나고 나서 생각났기 때문에 1.5솔이라고 생각했습니다.</p> <p data-ke-size="size16">&nbsp;</p> <p data-ke-size="size16">&nbsp;</p> <h2 data-ke-size="size26"><b>챌린지..!</b></h2> <p data-ke-size="size16">바로 다음주부터 챌린지가 시작되는데 꼭 합격해서 멤버십에 가고싶기 때문에ㅠㅠ 한달동안 열심히 달려보려고 합니다.</p> <p data-ke-size="size16">&nbsp;</p> <p data-ke-size="size16">+</p> <p data-ke-size="size16">그리고 부캠합격한 나에게 주는 선물 ☺️</p> <p><figure class='imageblock alignLeft' data-origin-width='704' data-origin-height='466' data-ke-mobilestyle='alignCenter'><span data-url='https://blog.kakaocdn.net/dn/cS86D3/btrHflVYZLR/WjiNHmSAXVGwJ9hDmFLOk0/img.png' data-lightbox='lightbox' data-alt=''><img src='https://blog.kakaocdn.net/dn/cS86D3/btrHflVYZLR/WjiNHmSAXVGwJ9hDmFLOk0/img.png' srcset='https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FcS86D3%2FbtrHflVYZLR%2FWjiNHmSAXVGwJ9hDmFLOk0%2Fimg.png' width='310' height='205' data-ke-mobilestyle='alignCenter'/></span></figure></p> <p data-ke-size="size16">&nbsp;</p>"#
        )
    }

    private func pubDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)

        let targetDateComponents = DateComponents(year: 2022, month: 7, day: 14, hour: 10, minute: 22, second: 3)
        let pubDate = calendar.date(from: targetDateComponents)
        return pubDate ?? Date()
    }
}
