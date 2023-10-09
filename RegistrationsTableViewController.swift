//  RegistrationsTableViewController.swift
//  Hotel Manzana
//  Created by .b[u]mpagram  on 8/10/23.
//
import UIKit

class RegistrationsTableViewController: UITableViewController {
    
    var allRegistrations = [Registration]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    @IBAction func unwindCustomFromAddRegistration(onsegue: UIStoryboardSegue) {  // Подключен,но xcode кружок не закрасил
        guard let addRegistrationTVC = onsegue.source as? AddRegistrationTVC,
              let registration = addRegistrationTVC.registration else {return}
        allRegistrations.append(registration)
        tableView.reloadData()
    }
    
    @IBSegueAction func showDetailsSegue(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> AddRegistrationTVC? {
        return AddRegistrationTVC(coder: coder)
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRegistrations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let tappedCell = allRegistrations[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = tappedCell.firstName + " " + tappedCell.lastName
        content.secondaryText = tappedCell.checkInDate.formatted(date: .numeric, time: .omitted) + " - " + tappedCell.checkOutDate.formatted(date: .numeric, time: .omitted) + ":   " + tappedCell.roomType.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // тут надо будет дописать логику под переход в экран детали, если будет
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

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showDetails" {
            print("YEEEAAAHH")
            print(segue.destination)
            AddRegistrationTVC.fromTappedCellToDetails = true
        }
    }
    

}
