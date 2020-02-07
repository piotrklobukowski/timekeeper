//
//  DurationSettingsViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 05/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class DurationSettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewForSettingPickerView: UIView!
    @IBOutlet var settingPickerView: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    
    let minutes = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    let seconds = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        saveButton.layer.cornerRadius = 30
        
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
        label1.textColor = UIColor(red:0.20, green:0.51, blue:0.72, alpha:1.0)
        
        settingPickerView.addSubview(label1)
        
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.centerYAnchor.constraint(equalTo: viewForSettingPickerView.centerYAnchor).isActive = true
        label1.centerXAnchor.constraint(equalTo: viewForSettingPickerView.centerXAnchor).isActive = true
      


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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

        label.textColor = UIColor(red:0.20, green:0.51, blue:0.72, alpha:1.0)

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
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
    
    
    
    
   

}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


