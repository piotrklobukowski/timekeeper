//
//  SettingsTableViewController.swift
//  Timekeeper
//
//  Created by Piotr Kłobukowski on 11/01/2020.
//  Copyright © 2020 Piotr Kłobukowski. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var settings = Settings()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        settings.loadAllSettings()
//        print(settings.clockworkConfigurations[0]?.count)
//        print(settings.clockworkConfigurations[1]?.count)
//        print(settings.clockworkConfigurations[2]?.count)
//        print(settings.clockworkConfigurations[3]?.count)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red:0.11, green:0.15, blue:0.17, alpha:1.0)

        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red:0.73, green:0.88, blue:0.98, alpha:1.0)
    }
    
    
    enum settingsSections: Int {
        case duration = 0
        case numberOfBreaks = 1
        case soundSettings = 2
        case ohter = 3
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.clockworkConfigurations.count
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        switch section {
        case settingsSections.duration.rawValue:
            return "Duration"
        case settingsSections.numberOfBreaks.rawValue:
            return "Number of breaks"
        case settingsSections.soundSettings.rawValue:
            return "Sound settings"
        case settingsSections.ohter.rawValue:
            return "Ohter"
        default:
            return "nil"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.clockworkConfigurations[section]!.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting Cell", for: indexPath)
        
        cell.textLabel?.text = settings.clockworkConfigurations[indexPath.section]![indexPath.row].descriptionOfSetting
        
        switch indexPath.section {
        case settingsSections.duration.rawValue:
            cell.detailTextLabel?.text = "\(settings.clockworkConfigurations[indexPath.section]![indexPath.row].amount):00"
        case settingsSections.numberOfBreaks.rawValue:
            cell.detailTextLabel?.text = "\(settings.clockworkConfigurations[indexPath.section]![indexPath.row].amount)"
        default:
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OpenDurationSettings", sender: self)
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}





