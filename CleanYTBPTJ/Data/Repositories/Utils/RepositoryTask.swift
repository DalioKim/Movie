//
//  RepositoryTask.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/05.
//

import Foundation

class RepositoryTask: CancelDelegate {
    
    var networkTask: NetworkCancelDelegate?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
