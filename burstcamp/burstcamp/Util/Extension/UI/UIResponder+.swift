//
//  UIResponder+.swift
//  burstcamp
//
//  Created by youtak on 2022/12/08.
//

import UIKit

extension UIResponder {
    
    /// UIResponder에서 일어나는 에러를 처리함
    /// - Parameters:
    ///   - error: Error 타입
    ///   - uiResponder: UIResponder를 상속받는 UIViewController, UIView 등
    ///   - retryHandler: 재시도 할 때 실행할 클로져. default 값은 없음
    ///   @discussion
    ///     @objc 함수로 정의해야지 서브클래스 (AppDelegate, UIViewController, UIView 등)에서 override할 수 잇음
    @objc func handleError(
        _ error: Error,
        from uiResponder: UIResponder,
        retryHandler: @escaping () -> Void = {}
    ) {
        guard let nextResponder = next else {
            return assertionFailure("""
            처리할 수 없는 에러입니다 :  \(error)
            """)
        }

        nextResponder.handleError(
            error,
            from: uiResponder,
            retryHandler: retryHandler
        )
    }
}
