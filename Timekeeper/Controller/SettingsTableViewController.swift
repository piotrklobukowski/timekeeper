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
        settings.loadSettings()
        settings.addDefaultSettings()
        print(settings.clockworkConfiguration.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settings.clockworkConfiguration.count
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings.clockworkConfiguration[section].count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Setting Cell", for: indexPath)
        
        cell.textLabel?.text = settings.clockworkConfiguration[indexPath.section][indexPath.row].descriptionOfSetting
        
        switch indexPath.section {
        case 0:
            cell.detailTextLabel?.text = "\(settings.clockworkConfiguration[indexPath.section][indexPath.row].amount):00"
        case 1:
            cell.detailTextLabel?.text = "\(settings.clockworkConfiguration[indexPath.section][indexPath.row].amount)"
        default:
            cell.accessoryType = .disclosureIndicator
        }

        return cell
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



//        cell.textLabel?.text = settings.clockworkConfiguration[indexPath.row].descriptionOfSetting
//
//        if (settings.clockworkConfiguration[indexPath.row].descriptionOfSetting?.hasPrefix("Duration"))! {
//        cell.detailTextLabel?.text = "\(settings.clockworkConfiguration[indexPath.row].amount):00"
//        } else if (settings.clockworkConfiguration[indexPath.row].descriptionOfSetting?.hasPrefix("Number"))! {
//            cell.detailTextLabel?.text = "\(settings.clockworkConfiguration[indexPath.row].amount)"
//        } else {
//            cell.accessoryType = .disclosureIndicator
//        }

