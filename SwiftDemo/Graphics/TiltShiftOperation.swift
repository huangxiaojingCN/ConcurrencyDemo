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
        let dependencyImage = dependencies
          .compactMap { ($0 as? ImageDataProvider)?.image }
          .first

        guard let inputImage = inputImage ?? dependencyImage else {
          return
        }
        
        guard let filter = TiltShiftFilter(image: inputImage, radius: 3.0),
              let output = filter.outputImage else {
            print("Failed to generate tilt shift image")
            return
        }
        
        let fromRect = CGRect(origin: .zero, size: inputImage.size)
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
