//  AddRegistrationTVC.swift
//  Hotel Manzana
//  Created by .b[u]mpagram  on 4/10/23.
//
import UIKit

class AddRegistrationTVC: UITableViewController {

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var checkInDatePicker: UIDatePicker!
    @IBOutlet var checkOutDatePicker: UIDatePicker!
    @IBOutlet var checkInDateLabel: UILabel!
    @IBOutlet var checkOutDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = today
        checkInDatePicker.date = today
        updateDateViews()
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        print("DONE PRESSED")
        print(firstNameField.text ?? "")
        print(lastNameField.text ?? "")
        print(emailField.text ?? "")
        print(checkInDatePicker.date)
        print(checkOutDatePicker.date)
    }
    
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        updateDateViews()
    }
    
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)  // минимальный шаг в 1 день от даты въезда
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
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
