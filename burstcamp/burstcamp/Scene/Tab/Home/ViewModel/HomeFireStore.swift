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
    func fetchFeed()
}

final class HomeFireStoreService: HomeFireStore {

    private let database = Firestore.firestore()
    let feedPublisher = PassthroughSubject<[Feed], Error>()
    private var cancelBag = Set<AnyCancellable>()

    func fetchFeed() {
        var result = [Feed]()
        let feeds = database
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
                            case .failure(let error):
                                self.feedPublisher.send(completion: .failure(error))
                            case .finished:
                                self.feedPublisher.send(result)
                            }
                        } receiveValue: { feedWriter in
                            let feed = Feed(feedDTO: feedDTO, feedWriter: feedWriter)
                            result.append(feed)
                        }
                        .store(in: &self.cancelBag)
                }
            } else if let error = error {
                self.feedPublisher.send(completion: .failure(error))
            } else {
                self.feedPublisher.send(completion: .failure(FirebaseError.fetchFeedError))
            }
        }
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
