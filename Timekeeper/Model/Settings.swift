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

class Settings {
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext) {
        self.context = context
    }
    
    private let context: NSManagedObjectContext
    var durationSettings = [ClockworkSettings]()
    var breaksNumberSettings = [ClockworkSettings]()
    var soundSettings = [ClockworkSettings]()
    var anotherInformations = [ClockworkSettings]()
    var clockworkConfigurations: [Int:[ClockworkSettings]] = [:]
    
    private func addDefaultSettings() {
        
        guard durationSettings.isEmpty && breaksNumberSettings.isEmpty && soundSettings.isEmpty && anotherInformations.isEmpty else { return }
        
        let longBreaksLimit = provideDefaults(
            withID: SettingsDetailsType.longBreaksNumber.rawValue,
            of: "Number of long breaks",
            withAmount: 1,
            withString: nil)
        
        let shortBreaksLimit = provideDefaults(
            withID: SettingsDetailsType.shortBreaksNumber.rawValue,
            of: "Number of short breaks",
            withAmount: 3,
            withString: nil)
        
         breaksNumberSettings.append(contentsOf: [shortBreaksLimit, longBreaksLimit])
        
        let longBreakDuration = provideDefaults(
            withID: SettingsDetailsType.longBreak.rawValue,
            of: "Duration of long break",
            withAmount: 20,
            withString: nil)
        
        let shortBreakDuration = provideDefaults(
            withID: SettingsDetailsType.shortBreak.rawValue,
            of: "Duration of short break",
            withAmount: 5,
            withString: nil)
        
        let workTimeDuration = provideDefaults(
            withID: SettingsDetailsType.focusTime.rawValue,
            of: "Duration of focus time",
            withAmount: 25,
            withString: nil)
        
        durationSettings.append(contentsOf: [workTimeDuration, shortBreakDuration, longBreakDuration])
        
        let soundForAlert = provideDefaults(
            withID: SettingsDetailsType.alertSound.rawValue,
            of: "Sound for alert",
            withAmount: nil,
            withString: "Bell Sound Ring")
        
        soundSettings.append(soundForAlert)
        
        let creditsInformation = provideDefaults(
            withID: SettingsDetailsType.credits.rawValue,
            of: "Credits",
            withAmount: nil,
            withString: """
        
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
        
        buildClockworkConfiguration()

        saveSettings()
    }
    
    private func provideDefaults(withID id: Int, of description: String, withAmount amount: Double?, withString string: String?) -> ClockworkSettings {
        let clockworkSettings = ClockworkSettings(context: context)
        clockworkSettings.descriptionOfSetting = description
        clockworkSettings.id = Int32(id)
        
        if let providedAmount = amount {
            clockworkSettings.amount = providedAmount
        }
        
        if let providedString = string {
            clockworkSettings.settingString = providedString
        }
        
        return clockworkSettings
    }
    
    
    // MARK: - Model Manipulation Methods
    
    private func saveSettings() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func save(_ newValue: Any, for setting: ClockworkSettings, of type: SettingsDetailsType) {
        switch type {
        case .focusTime, .longBreak, .shortBreak, .longBreaksNumber, .shortBreaksNumber:
            guard let valueToSave = newValue as? Double else { return }
            setting.setValue(valueToSave, forKey: String.CoreData.amountKey.rawValue)
        case .alertSound:
            guard let valueToSave = newValue as? String else { return }
            setting.setValue(valueToSave, forKey: String.CoreData.settingStringKey.rawValue)
        case .credits:
            return
        }
        saveSettings()
    }
    
    func loadSpecificSetting(for type: SettingsDetailsType) throws -> [ClockworkSettings] {
        let request: NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", type.rawValue)
        request.predicate = predicate
        return try context.fetch(request)
    }
    
    func loadAllSettings() {
        let settingsTypes: [SettingsDetailsType] = [.focusTime, .shortBreak, .longBreak]
        let requestDuration = makeFetchRequest(with: settingsTypes.map { $0.rawValue })
        let requestNumberOfBreaks = makeFetchRequest(with: [SettingsDetailsType.shortBreaksNumber.rawValue, SettingsDetailsType.longBreaksNumber.rawValue])
        let requestSound = makeFetchRequest(with: [SettingsDetailsType.alertSound.rawValue])
        let requestAnotherInformations = makeFetchRequest(with: [SettingsDetailsType.credits.rawValue])
        
        do {
            durationSettings = try context.fetch(requestDuration)
            breaksNumberSettings = try context.fetch(requestNumberOfBreaks)
            soundSettings = try context.fetch(requestSound)
            anotherInformations = try context.fetch(requestAnotherInformations)
        } catch {
            print("Error fetching data \(error)")
        }
        
        buildClockworkConfiguration()
        
        addDefaultSettings()
    }
    
    private func buildClockworkConfiguration() {
        clockworkConfigurations = [
            0: durationSettings,
            1: breaksNumberSettings,
            2: soundSettings,
            3: anotherInformations
        ]
    }
    
    private func makeFetchRequest(with identifiers: [Int]) -> NSFetchRequest<ClockworkSettings> {
        let request : NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()

        let predicates: [NSPredicate] = identifiers.map { NSPredicate(format: "id == %d", $0) }
        let compoundPredicate = NSCompoundPredicate(type: .or, subpredicates: predicates)
        
        let sortDescriptor = NSSortDescriptor(key: String.CoreData.idKey.rawValue, ascending: true)
        request.predicate = compoundPredicate
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
    
}
