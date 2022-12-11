//
//  Publisher+Extension.swift
//  burstcamp
//
//  Created by SEUNGMIN OH on 2022/12/11.
//

import protocol Combine.Publisher
import enum Combine.Publishers

extension Publisher {
    func mapToVoid() -> Publishers.Map<Self, Void> {
        return self.map { _ in Void() }
    }
}
