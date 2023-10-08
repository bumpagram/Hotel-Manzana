//  SelectRoomTypeTVC.swift
//  Hotel Manzana
//  Created by .b[u]mpagram  on 7/10/23.
//
import UIKit

class SelectRoomTypeTVC: UITableViewController {
    
    var currentlySelectedRoomType: RoomType?
    // WEAK   Since another class will implement the protocol, you'll need to define a property to hold the reference to the implementing instance:
    var delegatee: SelectRoomTypeTVCDelegate?

    
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
        delegatee?.selectRoomTypeTableViewController(self, didSelect: tappedCell)  //референс в проперти, из него в протокол, из протокола в метод
        tableView.reloadData()
        performSegue(withIdentifier: "goToAddRegistration", sender: self)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
} // TableViewController end



protocol SelectRoomTypeTVCDelegate : AnyObject {
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTVC, didSelect roomType: RoomType)
    // кастомный протокол и метод тоже
}
