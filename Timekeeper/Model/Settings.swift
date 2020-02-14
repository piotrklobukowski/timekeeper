//
//  ClockworkSettings.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 28/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Settings {
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext) {
        self.context = context
    }
    
    let context: NSManagedObjectContext
    var durationSettings = [ClockworkSettings]()
    var breaksNumberSetting = [ClockworkSettings]()
    var soundSettings = [ClockworkSettings]()
    var anotherInformations = [ClockworkSettings]()
    var clockworkConfigurations: [Int:[ClockworkSettings]] = [:]
    
    var specificConfiguration = [ClockworkSettings]() // value for change specific setting
        
    mutating func addDefaultSettings() {
        
        guard durationSettings.isEmpty && breaksNumberSetting.isEmpty && soundSettings.isEmpty && anotherInformations.isEmpty else { return }
        
        let longBreaksLimit = provideDefaults(of: "Number of long breaks", with: 1, with: nil)
        let shortBreaksLimit = provideDefaults(of: "Number of short breaks", with: 3, with: nil)
         breaksNumberSetting.append(contentsOf: [longBreaksLimit, shortBreaksLimit])
        
        let longBreakDuration = provideDefaults(of: "Duration of long break", with: 20, with: nil)
        let shortBreakDuration = provideDefaults(of: "Duration of short break", with: 5, with: nil)
        let workTimeDuration = provideDefaults(of: "Duration of focus time", with: 25, with: nil)
        durationSettings.append(contentsOf: [longBreakDuration, shortBreakDuration, workTimeDuration])
        
        let soundForAlert = provideDefaults(of: "Sound for alert", with: nil, with: "Bell Sound Ring")
        soundSettings.append(soundForAlert)
        
        let creditsInformation = provideDefaults(of: "Credits", with: nil, with: """
        
        Timekeeper
        
        Created by Piotr Kłobukowski on 28/01/2020.
        Copyright © 2020 Piotr Kłobukowski. All rights reserved.
        
        In this project were used:
        iOS CircleProgressView - Copyright Cardinal Solutions 2013. Licensed under the MIT license.
        sounds:
        Bell Sound Ring - Mike Koenig
        Japanese Temple Small Bell - Mike Koenig
        Ship Bell - Mike Koenig
        Front Desk Bells - Daniel Simon
        
        """)
        anotherInformations.append(creditsInformation)
        
        clockworkConfigurations = [0: durationSettings, 1: breaksNumberSetting, 2: soundSettings, 3: anotherInformations]

        saveSettings()
    }
    
    private func provideDefaults(of description: String, with amount: Double?, with string: String?) -> ClockworkSettings {
        let clockworkSettings = ClockworkSettings(context: context)
        clockworkSettings.descriptionOfSetting = description
        
        if let providedAmount = amount {
            clockworkSettings.amount = providedAmount
        }
        
        if let providedString = string {
            clockworkSettings.settingString = providedString
        }
        
        return clockworkSettings
    }
    
    
    // MARK: - Model Manipulation Methods
    
    func saveSettings() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    mutating func loadSpecificSetting(of description: String) {
        let request: NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()
        let predicate = NSPredicate(format: "descriptionOfSetting MATCHES[cd] %@", description)
        request.predicate = predicate
        
        do {
            try specificConfiguration = context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    mutating func loadAllSettings() {
        
        let requestDuration = makeFetchRequest(with: "Duration")
        let requestNumberOfBreaks = makeFetchRequest(with: "Number")
        let requestSound = makeFetchRequest(with: "Sound")
        let requestAnotherInformations = makeFetchRequest(with: "Credits")
        
        do {
            durationSettings = try context.fetch(requestDuration)
            breaksNumberSetting = try context.fetch(requestNumberOfBreaks)
            soundSettings = try context.fetch(requestSound)
            anotherInformations = try context.fetch(requestAnotherInformations)
        } catch {
            print("Error fetching data \(error)")
        }
        clockworkConfigurations = [0: durationSettings, 1: breaksNumberSetting, 2: soundSettings, 3: anotherInformations]
    }
    
    private func makeFetchRequest(with argument: String) -> NSFetchRequest<ClockworkSettings> {
        let request : NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()
        let predicate = NSPredicate(format: "descriptionOfSetting CONTAINS[cd] %@", argument)
        let sortDescriptor = NSSortDescriptor(key: "descriptionOfSetting", ascending: true)
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
}
