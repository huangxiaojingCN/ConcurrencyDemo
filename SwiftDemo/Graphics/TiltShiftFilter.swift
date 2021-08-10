//
//  TiltShiftFilter.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/9.
//

import UIKit
import CoreGraphics

class TiltShiftFilter: CIFilter {
    private static let defaultRadius = 10.0
    
    public var inputImage: CIImage?
    public var inputRadius: Double = defaultRadius
    
    override var name: String {
        get {
            return "TiltShiftFilter"
        }
        set {}
    }
    
    override func setDefaults() {
        super.setDefaults()
        inputRadius = TiltShiftFilter.defaultRadius
    }
    
    override var inputKeys: [String] {
        get {
            return [kCIInputImageKey, kCIInputRadiusKey]
        }
    }
    
    private func ciImage(from filterName: String, paramters: [String: Any]) -> CIImage? {
        guard let filtered = CIFilter(name: filterName, parameters: paramters) else {
            return nil
        }
        
        return filtered.outputImage
    }
    
    override var outputImage: CIImage? {
        guard let inputImage = inputImage else {
            return nil
        }
        
        let clamped = inputImage.clampedToExtent()
        let blurredImage = clamped.applyingGaussianBlur(sigma: inputRadius)
        
        var gradientParameters = [
            "inputPoint0": CIVector(x: 0, y: 0.75 * inputImage.extent.height),
            "inputColor0": CIColor(red: 0, green: 1, blue: 0, alpha: 1),
            "inputPoint1": CIVector(x: 0, y: 0.5 * inputImage.extent.height),
            "inputColor1": CIColor(red: 0, green: 1, blue: 0, alpha: 0)
        ];
        
        guard let gradientImage = ciImage(from: "CILinearGradient", paramters: gradientParameters) else {
            return nil
        }
        
        gradientParameters["inputPoint0"] = CIVector(x: 0, y: 0.25 * inputImage.extent.height)
        
        guard let backgroundGradientImage = ciImage(from: "CILinearGradient", paramters: gradientParameters) else {
            return nil
        }
        
        let maskParamters = [
            kCIInputImageKey: gradientImage,
            kCIInputBackgroundImageKey: backgroundGradientImage
        ]
        
        guard let maskImage = ciImage(from: "CIAdditionCompositing", paramters: maskParamters) else {
            return nil
        }
        
        let combinedParamters = [
            kCIInputImageKey: blurredImage,
            kCIInputBackgroundImageKey: clamped,
            kCIInputMaskImageKey: maskImage
        ]
        
        return ciImage(from: "CIBlendWithMask", paramters: combinedParamters)
    }
    
    convenience init?(image: UIImage, radius: Double = TiltShiftFilter.defaultRadius) {
        guard let backing = image.ciImage ?? CIImage(image: image) else {
            return nil
        }
        
        self.init()

        inputImage = backing
        inputRadius = radius
    }
}
