//
//  BreaksAmountSettingViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 04/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class BreaksAmountSettingViewController: UIViewController, SettingsDetailsInterface {

    var detailsType: SettingsDetailsType?
    var settings : Settings?
    var delegate: SettingsUpdateDelegate?
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewForSettingPickerView: UIView!
    @IBOutlet var settingPickerView: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    
    private let breaksAmount = String.breaksAmount
    private var amountSettings : ClockworkSettings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingPickerView.delegate = self
        settingPickerView.dataSource = self
        
        loadSettingsAndView()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let newValue = transformValueFromPicker(),
        let type = detailsType,
        let breaksAmountSettings = amountSettings else { return }
        settings?.save(newValue, for: breaksAmountSettings, of: type)
        delegate?.settingsDidUpdate()
        navigationController?.popViewController(animated: true)
    }
    
    func loadSettingsAndView() {
        do {
        amountSettings = try loadBreaksAmountSettings()
        } catch {
            return
        }
        fillWithLoadedSettings()
    }
    
    private func transformValueFromPicker() -> Double? {
        let index = settingPickerView.selectedRow(inComponent: 0)
        guard let value = Double(breaksAmount[index]) else { return nil}
        return value
    }
    
    private func loadBreaksAmountSettings() throws -> ClockworkSettings? {
        guard let detailsType = detailsType else { return nil }
        return try settings?.loadSpecificSetting(for: detailsType).first
    }
    
    private func fillWithLoadedSettings() {
        guard let value = amountSettings?.amount else { return }
        let stringValue = String(format: "%i", Int(value))
        guard let valueIndex = breaksAmount.firstIndex(of: stringValue) else { return }
        settingPickerView.selectRow(valueIndex, inComponent: 0, animated: false)
        descriptionLabel.text = amountSettings?.descriptionOfSetting
    }
    
}

extension BreaksAmountSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breaksAmount.count
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
