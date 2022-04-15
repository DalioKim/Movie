//
//  API.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/04/03.
//

//MARK: 참고 블로그 주소: https://davidlinnn.medium.com/%E8%8F%AF%E9%BA%97%E7%9A%84-network-layer-c5c664dcca47

import RxSwift
import Moya

class API {
    static private let provider = MoyaProvider<MultiTarget>()
        
    static func request<T: DecodableResponseTargetType>(_ request: T) -> Single<T.ResponseType> {
        let target = MultiTarget.init(request)
        return API.provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(T.ResponseType.self)
    }
}
