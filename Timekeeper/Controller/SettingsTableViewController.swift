//
//  SettingsTableViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 11/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

protocol SettingsUpdateDelegate: AnyObject {
    func settingsDidUpdate()
}

class SettingsTableViewController: UITableViewController {
    
    var settings: Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSettings()
        settings?.loadAllSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupSettings() {
        if settings == nil {
            settings = Settings()
        }
    }
    
    private func clockworkConfiguration(at index: IndexPath) -> Double {
        let clockworkSettings = settings?.clockworkConfigurations[index.section]
        let settingsForIndex = clockworkSettings?[index.row]
        return settingsForIndex?.amount ?? 0
    }
    
    private lazy var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    private func settingsType(for index: IndexPath) -> SettingsDetailsType? {
        switch index.section {
        case SettingsSections.duration.rawValue:
            switch index.row {
            case 0: return SettingsDetailsType.focusTime
            case 1: return SettingsDetailsType.shortBreak
            case 2: return SettingsDetailsType.longBreak
            default: return nil
            }
        case SettingsSections.numberOfBreaks.rawValue:
            switch index.row {
            case 0: return SettingsDetailsType.longBreaksNumber
            case 1: return SettingsDetailsType.shortBreaksNumber
            default: return nil
            }
        default: return nil
        }
    }

    // MARK: - Table view data source
    
    private enum SettingsSections: Int {
        case duration
        case numberOfBreaks
        case soundSettings
        case other
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.backgroundColor

        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.fontColor
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let amountOfSections = settings?.clockworkConfigurations.count else { return 0 }
        return amountOfSections
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let settingsSection = SettingsSections(rawValue: section) else { return nil }
        switch settingsSection {
        case .duration:
            return "Duration"
        case .numberOfBreaks:
            return "Number of breaks"
        case .soundSettings:
            return "Sound settings"
        case .other:
            return "Other"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numOfRowsInSect = settings?.clockworkConfigurations[section]?.count else { return 0 }
        return numOfRowsInSect
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.StoryboardIdentifiers.settingCell.rawValue , for: indexPath)
        
        cell.textLabel?.text = settings?.clockworkConfigurations[indexPath.section]?[indexPath.row].descriptionOfSetting
        
        if let settingsSection = SettingsSections(rawValue: indexPath.section) {
            switch settingsSection {
            case .duration:
                let duration = clockworkConfiguration(at: indexPath)
                cell.detailTextLabel?.text = formatter.clockFormat(from: duration)
            case .numberOfBreaks:
                let numberOfBreaks = Int(clockworkConfiguration(at: indexPath))
                cell.detailTextLabel?.text = String(format: "%i", numberOfBreaks)
            default:
                cell.accessoryType = .disclosureIndicator
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let settingsSection = SettingsSections(rawValue: indexPath.section) else { return }
        switch settingsSection {
        case .duration:
            performSegue(withIdentifier: String.StoryboardIdentifiers.segueOpenDurationSettings.rawValue, sender: self)
        case .numberOfBreaks:
            performSegue(withIdentifier: String.StoryboardIdentifiers.segueOpenBreaksAmountSettings.rawValue, sender: self)
        case .soundSettings:
            performSegue(withIdentifier: String.StoryboardIdentifiers.segueOpenSoundSettings.rawValue, sender: self)
        case .other:
            performSegue(withIdentifier: String.StoryboardIdentifiers.segueOpenCredits.rawValue, sender: self)
        }
    }
    
    // MARK: - Segue Preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let senderIndexPath = (sender as? SettingsTableViewController)?.tableView.indexPathForSelectedRow,
            var settingsDetails = segue.destination as? SettingsDetailsInterface else { return }
        
        settingsDetails.settings = settings
        settingsDetails.delegate = self
        
        switch segue.identifier {
        case String.StoryboardIdentifiers.segueOpenDurationSettings.rawValue:
            settingsDetails.detailsType = settingsType(for: senderIndexPath)
        case String.StoryboardIdentifiers.segueOpenBreaksAmountSettings.rawValue:
            settingsDetails.detailsType = settingsType(for: senderIndexPath)
        case String.StoryboardIdentifiers.segueOpenSoundSettings.rawValue:
            settingsDetails.detailsType = .alertSound
        case String.StoryboardIdentifiers.segueOpenCredits.rawValue:
            settingsDetails.detailsType = .credits
        default:
            return
        }
    }

}

extension SettingsTableViewController: SettingsUpdateDelegate {
    
    func settingsDidUpdate() {
        tableView.reloadData()
    }
}
