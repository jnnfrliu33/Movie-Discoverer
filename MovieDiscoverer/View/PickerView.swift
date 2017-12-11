//
//  PickerView.swift
//  MovieDiscoverer
//
//  Created by Jennifer Liu on 11/12/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import Foundation
import UIKit

// MARK: PickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate

class PickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: Properties
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    
    // MARK: Initializer
    
    init(pickerData: [String], pickerTextField: UITextField) {
        super.init(frame: .zero)
        
        self.pickerData = pickerData
        self.pickerTextField = pickerTextField
        
        self.delegate = self
        self.dataSource = self
        
        performUIUpdatesOnMain {
            if pickerData.count > 0 {
                self.pickerTextField.isEnabled = true
            } else {
                self.pickerTextField.isEnabled = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
        pickerTextField.resignFirstResponder()
    }
}
