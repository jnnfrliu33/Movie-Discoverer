//
//  UITextField.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 11/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UITextField

extension UITextField {
    
    func loadPickerView(data: [String]) {
        self.inputView = PickerView(pickerData: data, pickerTextField: self)
    }
}
