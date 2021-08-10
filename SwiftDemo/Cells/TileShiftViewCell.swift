//
//  TileShiftViewCell.swift
//  SwiftDemo
//
//  Created by 黄小净 on 2021/8/9.
//

import UIKit

class TileShiftViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var myImageView: UIImageView!
    
    static let identifer = "TileShiftViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifer, bundle: nil)
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator.isAnimating
        }
        
        set {
            if newValue {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func display(image: UIImage?) {
        self.myImageView.image = image
    }
}
