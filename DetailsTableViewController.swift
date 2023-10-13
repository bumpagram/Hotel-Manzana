//  DetailsTableViewController.swift
//  Hotel Manzana
//  Created by .b[u]mpagram  on 11/10/23.

import UIKit

class DetailsTableViewController: UITableViewController {

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var checkinDateLabel: UILabel!
    @IBOutlet var checkoutDateLabel: UILabel!
    @IBOutlet var numberAdultsLabel: UILabel!
    @IBOutlet var numberChildrenLabel: UILabel!
    @IBOutlet var numberNightsLabel: UILabel!
    @IBOutlet var detailNightsLabel: UILabel!
    @IBOutlet var costSelectedRoomLabel: UILabel!
    @IBOutlet var detailsSelectedRoomLabel: UILabel!
    @IBOutlet var costWifiLabel: UILabel!
    @IBOutlet var detailsWifiLabel: UILabel!
    @IBOutlet var totalCheckoutLabel: UILabel!
    
    var elementToShow: Registration?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("details viewDidLoad")
        updateUI()
    }
   
    
    func updateUI() {
        guard elementToShow != nil else { print("got nil at details sceen"); return}
        
        firstNameField.text = elementToShow?.firstName
        lastNameField.text = elementToShow?.lastName
        emailField.text = elementToShow?.emailAddress
        checkinDateLabel.text = elementToShow?.checkInDate.formatted(date: .abbreviated , time: .omitted)
        checkoutDateLabel.text = elementToShow?.checkOutDate.formatted(date: .abbreviated, time: .omitted)
        numberAdultsLabel.text = elementToShow?.numberOfAdults.formatted()
        numberChildrenLabel.text = elementToShow?.numberOfChildren.formatted()
        let daysInHotel = Calendar.current.dateComponents([.day], from: elementToShow!.checkInDate, to: elementToShow!.checkOutDate).day!
        numberNightsLabel.text = daysInHotel.formatted()
        detailNightsLabel.text = checkinDateLabel.text! + " - " + checkoutDateLabel.text!
        costSelectedRoomLabel.text = "$ " + (elementToShow!.roomType.price * daysInHotel).formatted()
        detailsSelectedRoomLabel.text = "\(elementToShow!.roomType.shortName) at $\(elementToShow!.roomType.price)/night"
        costWifiLabel.text = elementToShow!.wifi ? "$ \(daysInHotel * 10)" : "0"
        detailsWifiLabel.text = elementToShow!.wifi ? "Yes" : "No"
        totalCheckoutLabel.text = "$ " + elementToShow!.totalCheckout.formatted()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
