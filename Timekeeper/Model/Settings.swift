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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var clockworkConfiguration = [[ClockworkSettings]]()
    var durationSettings = [ClockworkSettings]()
    var breaksNumberSetting = [ClockworkSettings]()
    var soundSettings = [ClockworkSettings]()
    var anotherInformations = [ClockworkSettings]()
        
    mutating func addDefaultSettings() {
        if clockworkConfiguration.count == 0 {
            let longBreaksLimit = ClockworkSettings(context: context)
            longBreaksLimit.descriptionOfSetting = "Number of long breaks"
            longBreaksLimit.amount = 1
            let shortBreaksLimit = ClockworkSettings(context: context)
            shortBreaksLimit.descriptionOfSetting = "Number of short breaks"
            shortBreaksLimit.amount = 3
            breaksNumberSetting.append(contentsOf: [longBreaksLimit, shortBreaksLimit])
            
            let longBreakDuration = ClockworkSettings(context: context)
            longBreakDuration.descriptionOfSetting = "Duration of long break"
            longBreakDuration.amount = 20
            let shortBreakDuration = ClockworkSettings(context: context)
            shortBreakDuration.descriptionOfSetting = "Duration of short break"
            shortBreakDuration.amount = 5
            let workTimeDuration = ClockworkSettings(context: context)
            workTimeDuration.descriptionOfSetting = "Duration of focus time"
            workTimeDuration.amount = 25
            durationSettings.append(contentsOf: [longBreakDuration, shortBreakDuration, workTimeDuration])
            
            let soundForAlert = ClockworkSettings(context: context)
            soundForAlert.descriptionOfSetting = "Sound for alert"
            soundForAlert.settingString = "Bell Sound Ring"
            soundSettings.append(soundForAlert)
            
            let creditsInformation = ClockworkSettings(context: context)
            creditsInformation.descriptionOfSetting = "Credits"
            creditsInformation.settingString = """
            
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
            
            """
            anotherInformations.append(creditsInformation)
            clockworkConfiguration.append(contentsOf: [durationSettings, breaksNumberSetting, soundSettings, anotherInformations])
            saveSettings()
        } else {
            return
        }
    }
    
    
    
    
    // MARK: - Model Manipulation Methods
    func saveSettings() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    mutating func loadSettings() {
        
        let requestDuration : NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()
        let predicateDuration = NSPredicate(format: "descriptionOfSetting CONTAINS[cd] %@", "Duration")
        let sortDescriptorDuration = NSSortDescriptor(key: "descriptionOfSetting", ascending: true)
        requestDuration.predicate = predicateDuration
        requestDuration.sortDescriptors = [sortDescriptorDuration]

        
        let requestNumberOfBreaks : NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()
        let predicateNumberOfBreaks = NSPredicate(format: "descriptionOfSetting CONTAINS[cd] %@", "Number")
        let sortDescriptorNumberOfBreaks = NSSortDescriptor(key: "descriptionOfSetting", ascending: true)
        requestNumberOfBreaks.predicate = predicateNumberOfBreaks
        requestNumberOfBreaks.sortDescriptors = [sortDescriptorNumberOfBreaks]
        
        let requestSound : NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()
        let predicateSound = NSPredicate(format: "descriptionOfSetting CONTAINS[cd] %@", "Sound")
        let sortDescriptorSound = NSSortDescriptor(key: "descriptionOfSetting", ascending: true)
        requestSound.predicate = predicateSound
        requestSound.sortDescriptors = [sortDescriptorSound]
        
        let requestAnotherInformations : NSFetchRequest<ClockworkSettings> = ClockworkSettings.fetchRequest()
        let predicateAnotherInformations = NSPredicate(format: "descriptionOfSetting CONTAINS[cd] @%", "Credits")
        let sortDescriptorAnotherInformations = NSSortDescriptor(key: "descriptionOfSetting", ascending: true)
        requestAnotherInformations.predicate = predicateAnotherInformations
        requestAnotherInformations.sortDescriptors = [sortDescriptorAnotherInformations]
        
        do {
            durationSettings = try context.fetch(requestDuration)
            breaksNumberSetting = try context.fetch(requestNumberOfBreaks)
            soundSettings = try context.fetch(requestSound)
            anotherInformations = try context.fetch(requestAnotherInformations)
        } catch {
            print("Error fetching data \(error)")
        }
        clockworkConfiguration.append(contentsOf: [durationSettings, breaksNumberSetting, soundSettings, anotherInformations])
    }
    
}
