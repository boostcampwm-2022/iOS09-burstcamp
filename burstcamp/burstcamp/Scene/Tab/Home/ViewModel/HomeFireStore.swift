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
    var isFetching: Bool { get set }
    func fetchFeed() -> AnyPublisher<[Feed], Error>
}

final class HomeFireStoreService: HomeFireStore {

    private let database = Firestore.firestore()
    private var cancelBag = Set<AnyCancellable>()
    private var lastSnapShot: QueryDocumentSnapshot?
    var isFetching: Bool = false

    func fetchFeed() -> AnyPublisher<[Feed], Error> {
        isFetching = true

        return Future<[Feed], Error> { [weak self] promise in
            guard let self = self else { return }

            var result: [Feed] = []

            let feeds = self.makeQuery(lastSnapShot: self.lastSnapShot)
            feeds.getDocuments { querySnapshot, _ in
                guard let querySnapshot = querySnapshot else { return }
                self.lastSnapShot = querySnapshot.documents.last

                querySnapshot.documents.forEach { queryDocumentSnapshot in
                    let data = queryDocumentSnapshot.data()
                    let feedDTO = FeedDTO(data: data)
                    self.fetchWriter(userUUID: feedDTO.writerUUID)
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
                        } receiveValue: { feedWriter in
                            let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
                            result.append(feed)
                        }
                        .store(in: &self.cancelBag)
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func makeQuery(lastSnapShot: QueryDocumentSnapshot?) -> Query {
        if let lastSnapShot = lastSnapShot {
            return database
                .collection("Feed")
                .order(by: "pubDate", descending: true)
                .start(afterDocument: lastSnapShot)
        } else {
            return database
                .collection("Feed")
                .order(by: "pubDate", descending: true)
                .limit(to: 10)
        }
    }

    private func fetchWriter(userUUID: String) -> AnyPublisher<FeedWriter, Error> {
        Future<FeedWriter, Error> { [weak self] promise in
            self?.database
                .collection("User")
                .document(userUUID)
                .getDocument { documentSnapShot, error in
                    if let documentSnapShot = documentSnapShot,
                       let userData = documentSnapShot.data() {
                        let feedWriter = FeedWriter(data: userData)
                        promise(.success(feedWriter))
                    } else if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.failure(FirebaseError.fetchUserError))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
