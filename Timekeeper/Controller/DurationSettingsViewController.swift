//
//  DurationSettingsViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 05/02/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class DurationSettingsViewController: UIViewController, SettingsDetailsInterface {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewForSettingPickerView: UIView!
    @IBOutlet var settingPickerView: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var colon: UILabel!
    
    weak var delegate: SettingsUpdateDelegate?

    let minutes = String.timeSixty
    let seconds = String.timeSixty
    
    var settings: Settings?
    var detailsType: SettingsDetailsType?
    
    private var durationSettings: ClockworkSettings?
    
    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private lazy var numberFormatter: NumberFormatter = {
        return NumberFormatter()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingPickerView.delegate = self
        settingPickerView.dataSource = self
        
        loadSettingsAndView()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let selectedTime = transformValueFromPicker(),
            let type = detailsType,
        let newSetting = durationSettings else { return }
        settings?.save(selectedTime, for: newSetting, of: type)
        delegate?.settingsDidUpdate()
        navigationController?.popViewController(animated: true)
        print("Perform save for new value: \(selectedTime)")
    }
    
    func loadSettingsAndView() {
        do {
            durationSettings = try loadDurationSettings()
        } catch {
            return
        }
        fillWithLoadedSettings()
    }
    
    private func transformValueFromPicker() -> Double? {
        guard let selectedMinutesRow = settingPickerView?.selectedRow(inComponent: Components.minutes),
            let selectedSecondsRow = settingPickerView?.selectedRow(inComponent: Components.seconds) else { return nil }
        
        let selectedMinutes = minutes[selectedMinutesRow]
        let selectedSeconds = seconds[selectedSecondsRow]
        
        guard let minutes = numberFormatter.number(from: selectedMinutes)?.doubleValue,
            let seconds = numberFormatter.number(from: selectedSeconds)?.doubleValue
            else { return nil }
        
        let double: Double = {
            var value = minutes * 60 + seconds
            if value < 5.0 {
                value = 5.0
            }
            return value
        }()
        
        return double
    }
    
    private func provideValueForPickerView(value: Double) {
        guard let timeString = formatter.clockFormat(from: value) else { return }
        
        let substrings = timeString.split(separator: ":")
        
        let minutes = String(substrings[0])
        let seconds = String(substrings[1])
        
        guard let minutesIndex = self.minutes.firstIndex(of: minutes) else { return }
        guard let secondsIndex = self.seconds.firstIndex(of: seconds) else { return }
       
        settingPickerView.selectRow(minutesIndex, inComponent: Components.minutes, animated: false)
        settingPickerView.selectRow(secondsIndex, inComponent: Components.seconds, animated: false)
    }
    
    private func loadDurationSettings() throws -> ClockworkSettings? {
        guard let detailsType = detailsType else { return nil }
        return try settings?.loadSpecificSetting(for: detailsType).first
    }
    
    private func fillWithLoadedSettings() {
        guard let value = durationSettings?.amount else { return }
        provideValueForPickerView(value: value)
        descriptionLabel.text = durationSettings?.descriptionOfSetting
    }
}

extension DurationSettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    private enum Components {
        static var minutes = 0
        static var seconds = 2
        static var colon = 1
        static var comoponentsCount = 3
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Components.comoponentsCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case Components.minutes:
            return minutes.count
        case Components.seconds:
            return seconds.count
        default:
            return 0
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
        label.font = .systemFont(ofSize: (viewForSettingPickerView.frame.size.height * 0.45))
        
        colon.textColor = UIColor.trackColor
        colon.font = .systemFont(ofSize: (viewForSettingPickerView.frame.size.height * 0.45))
        colon.textAlignment = .center
        
        switch component {
        case Components.minutes:
            label.textAlignment = .right
            label.text = minutes[row]
        case Components.seconds:
            label.textAlignment = .left
            label.text = seconds[row]
        default:
            label.textAlignment = .center
            label.text = nil
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case Components.minutes, Components.seconds:
            return (settingPickerView.frame.size.width * 0.4)
        case Components.colon:
            return (settingPickerView.frame.size.width * 0.2)
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return viewForSettingPickerView.frame.size.height
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard pickerView.selectedRow(inComponent: Components.minutes) == minutes.firstIndex(of: "00") else { return }
        guard let minValue = seconds.firstIndex(of: "05") else { return }
        guard pickerView.selectedRow(inComponent: Components.seconds) < minValue else { return }
        pickerView.selectRow(minValue, inComponent: Components.seconds, animated: true)
    }
    
}

extension DurationSettingsViewController: UIPickerViewAccessibilityDelegate {
    
    func pickerView(_ pickerView: UIPickerView, accessibilityLabelForComponent component: Int) -> String? {
        switch component {
        case Components.minutes:
            return "minutes"
        case Components.seconds:
            return "seconds"
        default:
            return nil
        }
    }
}
