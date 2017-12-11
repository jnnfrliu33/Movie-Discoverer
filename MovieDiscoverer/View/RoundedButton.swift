//
//  RoundedButton.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 08/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit

// MARK: - RoundedButton: UIButton

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
