//
//  SoundSettingViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 04/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit
import AVFoundation

class SoundSettingViewController: UIViewController, SettingsDetailsInterface {
    
    var detailsType: SettingsDetailsType?
    var settings: Settings?
    var delegate: SettingsUpdateDelegate?
    
    private var soundSettings: ClockworkSettings?
    private let sounds = String.sounds
    private var player = AVPlayer()
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var viewForSettingPickerView: UIView!
    @IBOutlet var settingPickerView: UIPickerView!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingPickerView.delegate = self
        settingPickerView.dataSource = self
        
        loadSettingsAndView()
    }
    
    func loadSettingsAndView() {
        do {
        soundSettings = try loadSoundSettings()
        } catch {
            return
        }
        fillWithLoadedSettings()
    }
    
    private func loadSoundSettings() throws -> ClockworkSettings? {
        guard let detailsType = detailsType else { return nil }
        return try settings?.loadSpecificSetting(for: detailsType).first
    }
    
    private func fillWithLoadedSettings() {
        guard let soundSettingsString = soundSettings?.settingString else { return }
        let transformedTitle = soundSettingsString.replacingOccurrences(of: "_", with: " ")
        guard let soundIndex = sounds.index(of: transformedTitle) else { return }
        settingPickerView.selectRow(soundIndex, inComponent: 0, animated: false)
        descriptionLabel.text = soundSettings?.descriptionOfSetting
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let index = settingPickerView.selectedRow(inComponent: 0)
        let sound = sounds[index]
        let soundTitle = sound.replacingOccurrences(of: " ", with: "_")
        guard let url = Bundle.main.url(forResource: soundTitle, withExtension: "mp3") else { sender.isEnabled = true; return }
        play(url: url)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard let newValue = transformValueFromPicker(),
            let type = detailsType,
            let soundSettings = soundSettings else { return }
        settings?.save(newValue, for: soundSettings, of: type)
        navigationController?.popViewController(animated: true)
    }
    
    private func transformValueFromPicker() -> String? {
        let index = settingPickerView.selectedRow(inComponent: 0)
        let sound = sounds[index]
        return sound.replacingOccurrences(of: " ", with: "_")
    }
    
    private func play(url: URL) {
        let item = AVPlayerItem(url: url)
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        
        player = AVPlayer(playerItem: item)
        player.play()
    }
    
    @objc func playerDidFinishPlaying(sender: Notification) {
        playButton.isEnabled = true
    }
}

extension SoundSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sounds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let vw = view as? UILabel {
            label = vw
        } else {
            label = UILabel()
        }
        
        label.textColor = UIColor.trackColor
        
        label.font = UIFont.systemFont(ofSize: (viewForSettingPickerView.frame.size.height * 0.25))
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = sounds[row]
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return settingPickerView.frame.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return viewForSettingPickerView.frame.size.height
    }
}
