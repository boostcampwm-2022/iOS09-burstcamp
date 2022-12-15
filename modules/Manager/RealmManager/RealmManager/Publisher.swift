//
//  Publisher.swift
//  RealmManager
//
//  Created by SEUNGMIN OH on 2022/12/13.
//

import struct Combine.AnyPublisher

import protocol RealmSwift.RealmFetchable
import struct RealmSwift.Results
import protocol RealmSwift.RealmCollection
import RealmSwift

extension Container {
    public func collectionPublisher<T: RealmFetchable>(_ type: T.Type)
    -> AnyPublisher<Results<T>, Error> {
        return object(type)
            .collectionPublisher
            .threadSafeReference()
            .eraseToAnyPublisher()
    }

    /// Collection의 변경사항들을 방출하는 publisher
    ///
    /// @discussion
    /// 변경사항들을 insertion, deletion, modification으로 분류해 반영해야 할 때 사용.
    ///
    /// - SeeAlso:
    ///
    /// ```swift
    ///     container.publisher(RealmModel.self)
    ///         .sink { [weak self] (changes: RealmCollectionChange) in
    ///             guard let tableView = self?.tableView else { return }
    ///             
    ///             switch changes {
    ///             case .initial:
    ///                 tableView.reloadData()
    ///             case .update(_, let deletions, let insertions, let modifications):
    ///
    ///             tableView.performBatchUpdates({
    ///                 tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
    ///                                      with: .automatic)
    ///                 tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
    ///                                      with: .automatic)
    ///                 tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
    ///                                      with: .automatic)
    ///             }, completion: { finished in
    ///                 print("tableView Update 완료")
    ///             })
    ///         }
    ///         .store(in: &cancelBag)
    /// ```
    /// 출처 : [MongoDB - Object Change Listener](https://www.mongodb.com/docs/realm/sdk/swift/react-to-changes/#register-an-object-change-listener)


    public func publisher<T: RealmFetchable>(_ type: T.Type)
    -> AnyPublisher<RealmCollectionChange<Results<T>>, Never> {
        return object(type)
            .changesetPublisher
            .subscribe(on: serialQueue)
            .threadSafeReference()
            .eraseToAnyPublisher()
    }
}
