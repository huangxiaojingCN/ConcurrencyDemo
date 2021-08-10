//
//  TiltShiftOperation.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/9.
//

import UIKit
import Foundation

class TiltShiftOperation: Operation {
    private static let context = CIContext()
    
    var onImageProcessed: ((UIImage?) -> Void)?
    
    var outputImage: UIImage?
    private let inputImage: UIImage?
    
    init(image: UIImage? = nil) {
        inputImage = image
        super.init()
    }
    
    override func main() {
        var imageToProcess: UIImage
        
        if let inputImage = inputImage {
          // 1
          imageToProcess = inputImage
        } else {
          // 2
          let dependencyImage: UIImage? = dependencies
            .compactMap { ($0 as? ImageDataProvider)?.image }
            .first
          
          if let dependencyImage = dependencyImage {
            imageToProcess = dependencyImage
          } else {
            // 3
            return
          }
        }
        
        guard !isCancelled else {
            return
        }
        
        guard let filter = TiltShiftFilter(image: imageToProcess, radius: 3.0),
              let output = filter.outputImage else {
            print("Failed to generate tilt shift image")
            return
        }
        
        guard !isCancelled else {
            return
        }
        
        let fromRect = CGRect(origin: .zero, size: imageToProcess.size)
        guard let cgImage = TiltShiftOperation
                .context
                .createCGImage(output, from: fromRect) else {
            print("No image generated")
            return
        }
        
        self.outputImage = UIImage(cgImage: cgImage)
        
        if let onImageProcessed = self.onImageProcessed {
            DispatchQueue.main.async { [weak self] in
                onImageProcessed(self?.outputImage)
            }
        }
    }
}

extension TiltShiftOperation: ImageDataProvider {
    var image: UIImage? {
        return outputImage
    }
}
