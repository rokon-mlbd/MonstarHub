//
//  Observable+Logging.swift
//  MonstarHub
//
//  Created by Rokon on 1/4/21.
//  Copyright © 2021 Monstarlab. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func logError(prefix: String = "Error: ") -> Observable<Element> {
        return self.do(onNext: nil,
                       onError: { (error) in
                        print("\(prefix)\(error)")
            },
                       onCompleted: nil,
                       onSubscribe: nil,
                       onDispose: nil)

    }

    func logServerError(message: String) -> Observable<Element> {
        return self.do(onNext: nil,
                       onError: { (error) in
                        print("\(message)")
                        print("Error: \(error.localizedDescription). \n")
            },
                       onCompleted: nil,
                       onSubscribe: nil,
                       onDispose: nil)
    }

    func logNext() -> Observable<Element> {
        return self.do(onNext: { (element) in
                print("\(element)")
            },
                       onError: nil,
                       onCompleted: nil,
                       onSubscribe: nil,
                       onDispose: nil)

    }
}
