//
//  CreditsViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 04/03/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController, SettingsDetailsInterface {
    
    var detailsType: SettingsDetailsType?
    var credits: ClockworkSettings?
    var settings: Settings?
    var delegate: SettingsUpdateDelegate?
    
    @IBOutlet var creditsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            credits = try loadSoundSettings()
            fillWithLoadedSettings()
        } catch {
            print("Error loading credits")
        }
        
    }
    
    private func loadSoundSettings() throws -> ClockworkSettings? {
        guard let detailsType = detailsType else { return nil }
        return try settings?.loadSpecificSetting(for: detailsType).first
    }
    
    private func fillWithLoadedSettings() {
        creditsTextView.text = credits?.settingString
    }

}
