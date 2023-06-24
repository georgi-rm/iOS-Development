//
//  DetailsTableViewController.swift
//  Exam
//
//  Created by Georgi Manev on 5.02.23.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    var blockData: BlockDataInLocalDatabase? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
//            LocalDataManager.updateWeatherData()
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocalDataManager.updateBlocksData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataDetailCellIdentifier", for: indexPath)
        
        guard let blockData = self.blockData else {
            return cell
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Block hash"
            cell.detailTextLabel?.text = blockData.blockHash
        case 1:
            cell.textLabel?.text = "Block height"
            cell.detailTextLabel?.text = blockData.blockData?.height.description
        case 2:
            cell.textLabel?.text = "Block time"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            if let time = blockData.blockData?.eTime {
                cell.detailTextLabel?.text = dateFormatter.string(from: time)
            } else {
                cell.detailTextLabel?.text = ""
            }
        case 3:
            cell.textLabel?.text = "Merkle root"
            cell.detailTextLabel?.text = blockData.blockData?.merkleRoot
        case 4:
            cell.textLabel?.text = "Number of transactions"
            cell.detailTextLabel?.text = blockData.blockData?.txs.count.description ?? ""
        case 5:
            cell.textLabel?.text = "Nonce"
            cell.detailTextLabel?.text = blockData.blockData?.nonce
        default:
            break
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
