//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import PlaygroundSupport
import PlaygroundWithOSS

struct Example {
    init(of name: String, action: @escaping () -> Void) {
        print("------------", name, "------------")
        action()
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

let disposeBag = DisposeBag()

func getDataOrError(completionHandler: @escaping ((String?, Error?)) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
        //        return completionHandler((nil, NSError()))
        return completionHandler(("data fetched!", nil))
    }
}

var singleObservable: Single<String> {
    return Single.create { single in
        getDataOrError { (data, error) in
            if let error = error {
                single(.error(error))
                return
            }
            
            single(.success(data!))
        }
        return Disposables.create()
    }
}

Example(of: "singleObservable") {
    singleObservable
        .subscribe({
            print($0)
        })
        .disposed(by: disposeBag)
}

Example(of: "Observable.just(1).asSingle()") {
    // same as `singleObservable`
    Observable.just(1).asSingle()
        .subscribe({
            print($0)
        })
        .disposed(by: disposeBag)
}

enum Result {
    case success
    case error(Error)
}

func excuteWork(completionHandler: @escaping (Result) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//        return completionHandler(.error(NSError(domain: "hoge", code: 999, userInfo: nil)))
        return completionHandler(.success)
    }
}

var completableObservable: Completable {
    return Completable.create { completable in
        excuteWork { result in
            if case let .error(e) = result {
                completable(.error(e))
            }
            completable(.completed)
        }
        
        return Disposables.create {}
    }
}

Example(of: "completableObservable") {
    completableObservable
        .subscribe({
            print($0)
        })
        .disposed(by: disposeBag)
}

var maybeObservable: Maybe<String> {
    return Maybe<String>.create { maybe in
        maybe(.success("Maybe"))
        
        // OR
//        maybe(.completed)
        
        // OR
//        maybe(.error(NSError(domain: "hoge", code: 999, userInfo: nil)))
        
        return Disposables.create {}
    }
}

Example(of: "maybeObservable") {
    maybeObservable
        .subscribe({
            print($0)
        })
        .disposed(by: disposeBag)
}

Example(of: "Observable.just(1).asMaybe()") {
    // same as `maybeObservable`
    Observable.just(1).asMaybe()
        .subscribe({
            print($0)
        })
        .disposed(by: disposeBag)
}

