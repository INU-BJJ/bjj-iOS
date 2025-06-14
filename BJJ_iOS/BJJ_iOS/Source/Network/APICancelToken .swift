//
//  APICancelToken .swift
//  BJJ_iOS
//
//  Created by HyoTaek on 6/13/25.
//

import Foundation

public final class APICancelToken {
    private(set) var isCancelled = false
    private var cancelClosures: [() -> Void] = []
    private let lock = NSLock()
    
    func onRegister(_ cancelAPITask: @escaping () -> Void) {
        lock.lock()
        defer { lock.unlock() }
        
        if isCancelled {
            // 이미 취소된 경우, 클로저를 즉시 실행
            cancelAPITask()
        } else {
            // 아직 취소되지 않았다면, 클로저를 배열에 추가
            cancelClosures.append(cancelAPITask)
        }
    }
    
    func cancel() {
        lock.lock()
        defer { lock.unlock() }
        
        guard !isCancelled else { return }
        isCancelled = true
        
        // 등록된 모든 취소 클로저 실행
        cancelClosures.forEach { $0() }
        cancelClosures.removeAll()
    }
}
