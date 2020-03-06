//
//  DurationSettingsViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 05/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class DurationSettingsViewController: UIViewController {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewForSettingPickerView: UIView!
    @IBOutlet var settingPickerView: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    
    let minutes = String.timeSixty
    let seconds = String.timeSixty
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        settingPickerView.delegate = self
        settingPickerView.dataSource = self
        
        let font = UIFont.systemFont(ofSize: (viewForSettingPickerView.frame.size.height * 0.45))
        let fontSize: CGFloat = font.pointSize
        let componentWidth: CGFloat = viewForSettingPickerView.frame.width / CGFloat(settingPickerView.numberOfComponents)
        let x = viewForSettingPickerView.frame.size.width / 2
        let y = viewForSettingPickerView.frame.size.height * 0.4
        
        let label1 = UILabel(frame: CGRect(x: x, y: y, width: componentWidth * 0.4, height: fontSize))
        label1.font = font
        label1.textAlignment = .center
        label1.text = ":"
        label1.textColor = UIColor.trackColor
        
        settingPickerView.addSubview(label1)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.centerYAnchor.constraint(equalTo: viewForSettingPickerView.centerYAnchor).isActive = true
        label1.centerXAnchor.constraint(equalTo: viewForSettingPickerView.centerXAnchor).isActive = true
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
}

extension DurationSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 1:
            return 0
        default:
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return minutes[row]
        case 2:
            return seconds[row]
        default:
            return nil
        }
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
        
        switch component {
        case 0:
            label.textAlignment = .right
            label.text = minutes[row]
        case 2:
            label.textAlignment = .left
            label.text = seconds[row]
        default:
            label.textAlignment = .center
            label.text = "nil"
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0,2:
            return (settingPickerView.frame.size.width * 0.4)
        case 1:
            return (settingPickerView.frame.size.width * 0.2)
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return viewForSettingPickerView.frame.size.height
    }
}
