//  SelectRoomTypeTVC.swift
//  Hotel Manzana
//  Created by .b[u]mpagram  on 7/10/23.
//
import UIKit

class SelectRoomTypeTVC: UITableViewController {
    
    var currentlySelectedRoomType: RoomType?

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RoomType.all.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let room = RoomType.all[indexPath.row]
        var currentContent = cell.defaultContentConfiguration()
        currentContent.text = room.name
        currentContent.secondaryText = String(room.price)
        if currentlySelectedRoomType == room {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.contentConfiguration = currentContent
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tappedCell = RoomType.all[indexPath.row]
        currentlySelectedRoomType = tappedCell
        tableView.reloadData()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
