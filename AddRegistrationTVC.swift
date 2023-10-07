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
    @IBOutlet var numberAdultsLabel: UILabel!
    @IBOutlet var numberAdultsStepper: UIStepper!
    @IBOutlet var numberChildrenLabel: UILabel!
    @IBOutlet var numberChildrenStepper: UIStepper!
    
    
    let checkinDatePickerIndexPath = IndexPath(row: 1, section: 1)  // 1:1 это сам DatePicker
    let checkoutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    let checkinLabelCellIndexPath = IndexPath(row: 0, section: 1)  // а мы тыкаем на лейбл-заголовок ячейкой выше
    let checkOutLabelCellIndexPath = IndexPath(row: 2, section: 1)  // аналогично


    var isCheckinDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckinDatePickerVisible  // toggle переворот в случае изменения значения
        }
    }
    
    var isCheckoutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckoutDatePickerVisible
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = today
        checkInDatePicker.date = today
        updateDateViews()
        updateNumbers()
    }

    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        print("DONE PRESSED")
        print(firstNameField.text ?? "")
        print(lastNameField.text ?? "")
        print(emailField.text ?? "")
        print(checkInDatePicker.date)
        print(checkOutDatePicker.date)
        print(Int(numberAdultsStepper.value))
        print(Int(numberChildrenStepper.value))
    }
    
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        // странно, не работает
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        updateDateViews()
    }
    @IBAction func steppersValueChanged(_ sender: UIStepper) {
        updateNumbers()
    }
    
    
    func updateDateViews() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)  // минимальный шаг в 1 день от даты въезда
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateNumbers() {
        numberAdultsLabel.text = "\(Int(numberAdultsStepper.value))"
        numberChildrenLabel.text = "\(Int(numberChildrenStepper.value))"
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkinDatePickerIndexPath where isCheckinDatePickerVisible == false: return 0
        case checkoutDatePickerIndexPath where isCheckoutDatePickerVisible == false : return 0
            // добавил 2 кейса, тк я вручную размеры ячеек проставлял и авторесайз не работает
        case checkinDatePickerIndexPath where isCheckinDatePickerVisible == true: return 217.0
        case checkoutDatePickerIndexPath where isCheckoutDatePickerVisible == true : return 217.0
        default: return UITableView.automaticDimension
        }
    }
    
// этот метод был для автоматического ресайза ячеек, но тк я сделал руками, то он не влияет видимо
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath {
//        case checkinLabelCellIndexPath: return 217.0
//        case checkOutLabelCellIndexPath: return 217.0
//        default: return UITableView.automaticDimension
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == checkinLabelCellIndexPath && isCheckoutDatePickerVisible == false {
            isCheckinDatePickerVisible.toggle()
        } else if indexPath == checkOutLabelCellIndexPath && isCheckinDatePickerVisible == false {
            isCheckoutDatePickerVisible.toggle()
        } else if indexPath == checkinLabelCellIndexPath || indexPath == checkOutLabelCellIndexPath {
            isCheckinDatePickerVisible.toggle()
            isCheckoutDatePickerVisible.toggle()
        } else {
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    

   
    
    

} // UITableViewController end
