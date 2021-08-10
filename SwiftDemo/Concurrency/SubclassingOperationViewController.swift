//
//  SubclassingOperationViewController.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/8.
//

import UIKit

class SubclassingOperationViewController: UIViewController {
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        self.navigationItem.setLeftBarButton(UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back)), animated: true)
        
        self.navigationItem.title = "继承 Operation"
        
        let op = Operation1()
        op.completionBlock = { () -> Void in
            print("custom op completion...")
        }
        op.start()
    }
}

class Operation1: Operation {
    
    override func main() {
        print("执行任务....")
        sleep(2)
        print("执行任务结束...")
    }
}
