//
//  RepositoryTask.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/05.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
