//
//  HomeViewController+handleError.swift
//  burstcamp
//
//  Created by youtak on 2022/12/08.
//

import UIKit

extension HomeViewController {
    override func handleError(_ error: Error) {
        if let error = error as? FirestoreError, error == .lastFetchError {
            showToastMessage(text: error.localizedDescription)
        } else {
            super.handleError(error)
        }
    }
}
