//
//  HomeFireStore.swift
//  burstcamp
//
//  Created by youtak on 2022/11/29.
//

import Combine
import Foundation

import FirebaseFirestore

protocol HomeFireStore {
    func fetchFeed(isPagination: Bool) -> AnyPublisher<[Feed], Error>
}

final class HomeFireStoreService: HomeFireStore {

    private let database = Firestore.firestore()
    private var cancelBag = Set<AnyCancellable>()
    private var lastSnapShot: QueryDocumentSnapshot?
    var isFetching: Bool = false
    var canFetchMoreFeed: Bool = true

    func fetchFeed(isPagination: Bool) -> AnyPublisher<[Feed], Error> {
        return Future<[Feed], Error> { [weak self] promise in
            guard let self = self else { return }
            
            guard !self.isFetching else { return }
            self.isFetching = true

            if !self.canFetchMoreFeed && isPagination {
                promise(.failure(FirebaseError.lastFetchError))
            } else {
                self.canFetchMoreFeed = true
            }

            var result: [Feed] = []
            let feeds = self.makeQuery(lastSnapShot: self.lastSnapShot, isPagination: isPagination)

            feeds.getDocuments { querySnapshot, _ in
                guard let querySnapshot = querySnapshot else { return }
                self.lastSnapShot = querySnapshot.documents.last

                if self.lastSnapShot == nil { // 응답한 Feed가 없는 경우
                    self.canFetchMoreFeed = false
                    self.isFetching = false
                    promise(.failure(FirebaseError.lastFetchError))
                }

                querySnapshot.documents.forEach { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    let feedDTO = FeedDTO(data: data)
                    FirebaseUser.fetch(userUUID: feedDTO.writerUUID)
                        .sink { completion in
                            switch completion {
                            case .finished:
                                if result.count >= querySnapshot.documents.count {
                                    let sortedResult = result.sorted {
                                        $0.pubDate > $1.pubDate
                                    }
                                    promise(.success(sortedResult))
                                    self.isFetching = false
                                }
                            case .failure(let error):
                                promise(.failure(error))
                            }
                        } receiveValue: { user in
                            let feedWriter = user.toFeedWriter
                            let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
                            result.append(feed)
                        }
                        .store(in: &self.cancelBag)
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func makeQuery(lastSnapShot: QueryDocumentSnapshot?, isPagination: Bool) -> Query {
        if let lastSnapShot = lastSnapShot, isPagination {
            return database
                .collection("Feed")
                .order(by: "pubDate", descending: true)
                .start(afterDocument: lastSnapShot)
        } else {
            return database
                .collection("Feed")
                .order(by: "pubDate", descending: true)
                .limit(to: 5)
        }
    }
}
