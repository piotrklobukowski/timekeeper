//
//  SettingsTableViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 11/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

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

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red:0.11, green:0.15, blue:0.17, alpha:1.0)

        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red:0.73, green:0.88, blue:0.98, alpha:1.0)
    }
    
    private enum SettingsSections: Int {
        case duration = 0
        case numberOfBreaks = 1
        case soundSettings = 2
        case other = 3
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting Cell", for: indexPath)
        
        cell.textLabel?.text = settings?.clockworkConfigurations[indexPath.section]?[indexPath.row].descriptionOfSetting
        
        if let settingsSection = SettingsSections(rawValue: indexPath.section) {
            switch settingsSection {
            case .duration:
                let duration = clockworkConfiguration(at: indexPath)
                cell.detailTextLabel?.text = String(format: "%02d", duration)
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
        performSegue(withIdentifier: "OpenDurationSettings", sender: self)
    }
}
