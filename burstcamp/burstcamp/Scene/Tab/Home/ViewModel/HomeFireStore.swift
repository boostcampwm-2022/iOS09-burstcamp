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
    func fetchFeed() -> AnyPublisher<[Feed], Error>
}

final class HomeFireStoreService: HomeFireStore {

    private let database = Firestore.firestore()
    let feedPublisher = PassthroughSubject<[Feed], Error>()
    private var cancelBag = Set<AnyCancellable>()

    func fetchFeed() -> AnyPublisher<[Feed], Error> {
        Future<[Feed], Error> { [weak self] promise in
            guard let self = self else { return }
            var result = [Feed]()
            let feeds = self.database
                .collection("Feed")
                .order(by: "pubDate", descending: true)
                .limit(to: 20)

            feeds.getDocuments {  querySnapShot, error in
                if let querySnapShot = querySnapShot {
                    for document in querySnapShot.documents {
                        let data = document.data()
                        let feedDTO = FeedDTO(data: data)
                        self.fetchWriter(userUUID: feedDTO.writerUUID)
                            .sink { completion in
                                switch completion {
                                case .finished:
                                    break
                                case .failure(let error):
                                    print(error)
                                }
                            } receiveValue: { feedWriter in
                                let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
                                result.append(feed)
                            }
                            .store(in: &self.cancelBag)
                    }
                }
            }
            promise(.success(result))
        }
        .eraseToAnyPublisher()
    }

    func fetchWriter(userUUID: String) -> AnyPublisher<FeedWriter, Error> {
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
        }.eraseToAnyPublisher()
    }
}
