//
//  NetworkImageOperation.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/9.
//

import UIKit
import Foundation

typealias ImageOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
    
    private let url: URL
    private let completion: ImageOperationCompletion
    
    private var task: URLSessionDataTask?
    
    var outputImage: UIImage?
    
    init(url: URL,
         completion: ImageOperationCompletion = nil) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    convenience init?(string: String,
                      completion: ImageOperationCompletion = nil) {
        guard let url = URL(string: string) else {
            return nil
        }
        
        self.init(url: url, completion: completion)
    }
    
    override func main() {
        task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            
            guard let self = self else {
                return
            }
            
            defer {
                self.state = .finished
            }
            
            guard !self.isCancelled else { return }
            
            if let completion = self.completion {
                completion(data, response, error)
                return
            }
            
            guard error == nil,
                  let data = data else {
                return
            }
            
            self.outputImage = UIImage(data: data)
        })
        
        task?.resume()
        print("网络请求: \(task!)")
    }
    
    override func cancel() {
        super.cancel()
        print("取消网络请求: \(task!)")
        task?.cancel()
    }
}

extension NetworkImageOperation: ImageDataProvider {
    var image: UIImage? {
        return outputImage
    }
}
