//
//  ThreadViewController.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/8.
//

import UIKit

/**
    多线程编程方式:
    1. Thread
    2. Cocoa Operation (Operation 和 OperationQueue)
    3. Grand Central Dispatch (GCD)
 
    1. Thread
        三种线程中最轻量级的，需要自己管理线程生命周期
 
 */
class ThreadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemRed

//        createThread()
//        createThread2()
//        blockOperationTest()
        
        let operation = MyOperation()
        operation.completionBlock = { () -> Void in
            print("--operation.completionBlock--")
        }
        let queue = OperationQueue()
        queue.addOperation(operation)
        print("threadTest...")
    }
    
    func createThread() {
        for i in 0...10 {
            Thread.detachNewThread {
                print(i)
            }
        }
    }
    
    func createThread2() {
        let thread = Thread(target: self, selector: #selector(threadWorker), object: nil)
        
        thread.start()
    }
    
    @objc func threadWorker() {
        print("threadWorker: \(String(describing: Thread.current.name))")
    }
    
    // Operation 抽象类
    func blockOperationTest() {
        let operation = BlockOperation(block: { [weak self] in
            guard let myself = self else {
                return
            }
            myself.blockOperationThreadWorker()
        })
        
        let queue = OperationQueue()
        queue.addOperation(operation)
    }
    
    @objc func blockOperationThreadWorker() {
        print("blockOperationThreadWorker: \(Thread.isMainThread)")
    }
}

class MyOperation: Operation {
    override func main() {
        sleep(1)
        print("MyOperation")
    }
}
