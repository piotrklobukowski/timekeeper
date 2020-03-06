//
//  BreaksAmountSettingViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 04/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class BreaksAmountSettingViewController: UIViewController {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewForSettingPickerView: UIView!
    @IBOutlet var settingPickerView: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    
    let breaksAmount = String.breaksAmount
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingPickerView.delegate = self
        settingPickerView.dataSource = self
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BreaksAmountSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let vw = view as? UILabel {
            label = vw
        } else {
            label = UILabel()
        }
        
        label.textColor = UIColor.trackColor
        
        label.font = UIFont.systemFont(ofSize: (viewForSettingPickerView.frame.size.height * 0.45))
        
        label.textAlignment = .center
        label.text = breaksAmount[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return settingPickerView.frame.size.width * 0.4
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return viewForSettingPickerView.frame.size.height
    }
    
}
