//
//  OperationViewController.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/8.
//

import UIKit

class OperationViewController: UIViewController {
    
    private var button1: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("开始", for: .normal)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        button.backgroundColor = .systemRed
        return button
    }()
    
    private var button2: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("结束", for: .normal)
        button.addTarget(self, action: #selector(stop), for: .touchUpInside)
        button.backgroundColor = .systemRed
        return button
    }()
    
    var operation: BlockOperation?
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        let leftButtonItem = UIBarButtonItem()
//        leftButtonItem.title = "返回"
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back)), animated: true)

        
        // 会阻塞当前线程
        self.operation = BlockOperation {
            print("block operation completion block: \(self.operation?.isFinished)")
        }
                
        operation!.addExecutionBlock {
            for i in 1...10 {
                print("当前正在执行: \(i)")
                sleep(1)
            }
        }
        
        print("主线程: operation is ready: \(operation!.isReady)")
        
        view.addSubview(button1)
        view.addSubview(button2)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        button1.frame = CGRect(x: 20, y: view.bounds.height - 100, width: 100, height: 50)
        button2.frame = CGRect(x: button1.frame.width + 40, y: button1.frame.origin.y, width: 100, height: 50)
    }
    
    @objc func start() {
        if let operation = self.operation {
            DispatchQueue.global().async {
                operation.start()
            }
            print("operation excecting: \(operation.isExecuting)")
        }
    }
    
    @objc func stop() {
        if let operation = self.operation {
            operation.cancel()
            print("operation cancel: \(operation.isCancelled)")
        }
    }
}
