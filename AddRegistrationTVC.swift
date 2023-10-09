//  AddRegistrationTVC.swift
//  Hotel Manzana
//  Created by .b[u]mpagram  on 4/10/23.
//
import UIKit

class AddRegistrationTVC: UITableViewController, SelectRoomTypeTVCDelegate, UITextFieldDelegate {
    
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
    @IBOutlet var wifiSwitch: UISwitch!
    @IBOutlet var roomTypeLabel: UILabel!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var selectedRoomsCell: UITableViewCell!
    @IBOutlet var selectedWifiCell: UITableViewCell!
    @IBOutlet var costWifi: UILabel!
    @IBOutlet var costSelectedRoomLabel: UILabel!
    @IBOutlet var detailsSelectedRoomLabel: UILabel!
    @IBOutlet var numberSelectedNightsLabel: UILabel!
    @IBOutlet var detailsSelectedNightsLabel: UILabel!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var totalCheckoutLabel: UILabel!
    
    
    let checkinDatePickerIndexPath = IndexPath(row: 1, section: 1)  // 1:1 это сам DatePicker
    let checkoutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    let checkinLabelCellIndexPath = IndexPath(row: 0, section: 1)  // а мы тыкаем на лейбл-заголовок ячейкой выше
    let checkOutLabelCellIndexPath = IndexPath(row: 2, section: 1)

    var totalWifiCost = 0
    var totalRoomsCost = 0 // как буфер для расчетов
    var totalCheckoutForGuest : Int {  totalWifiCost + totalRoomsCost   }
    
    var roomType: RoomType?  // property to hold selected room type in another window

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
    
    var registration: Registration? {   // исчисляемое свойство создает экземпляр бронирования
        guard let roomType = roomType else {return nil}
        let newFirstName = firstNameField.text ?? ""
        let newLastName = lastNameField.text ?? ""
        let newEmail = emailField.text ?? ""
        let newCheckin = checkInDatePicker.date
        let newCheckout = checkOutDatePicker.date
        let adults = Int(numberAdultsStepper.value)
        let children = Int(numberChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        return Registration(firstName: newFirstName, lastName: newLastName, emailAddress: newEmail, checkInDate: newCheckin, checkOutDate: newCheckout, numberOfAdults: adults, numberOfChildren: children, wifi: hasWifi, roomType: roomType)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameField.delegate = self // чтобы переключаться между полями
        self.lastNameField.delegate = self
        self.emailField.delegate = self
        
        let today = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = today
        checkInDatePicker.date = today
        updateDateViews()
        updateNumbers()
        updateRooms()
        checkUserInputStatus()
        updateCharges()
    }
    
    
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        // странно, не работает
      resignTextFields()
    }
    @IBAction func datePickerValueChanged(_ sender: Any) {
        updateDateViews()
        updateCharges()
        resignTextFields()
    }
    @IBAction func steppersValueChanged(_ sender: UIStepper) {
        updateNumbers()
        checkUserInputStatus()
        resignTextFields()
    }
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateCharges()
        resignTextFields()
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        resignTextFields()
        dismiss(animated: true)
    }
    @IBAction func userTappedAnyButton(_ sender: UITextField) { 
        // экшен на проверку корректности текстового ввода переадресует в функцию с логикой
        checkUserInputStatus()
    }
    @IBAction func unwindToAddRegistration(segue: UIStoryboardSegue) {
        // Подключен,но xcode кружок не закрасил
        checkUserInputStatus()
        resignTextFields()
    }
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTVC? {
        let selectRoomController = SelectRoomTypeTVC(coder: coder)  // инициализируем ViewController и кладем его в константу
        selectRoomController?.delegatee = self  // на AddRegistrationTVC
        selectRoomController?.currentlySelectedRoomType = roomType
        return selectRoomController
    }
    
    
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTVC, didSelect roomType: RoomType) { 
        // метод протокола требуется имплементировать
        self.roomType = roomType
        updateRooms()
        updateCharges()
        resignTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { 
        // метод делегейта, при нажатии энтер в текстовом поле перейти к следующему полю или убрать клаву
        switch textField {
        case self.firstNameField : self.lastNameField.becomeFirstResponder()
        case self.lastNameField : self.emailField.becomeFirstResponder()
        default : self.emailField.resignFirstResponder()
        }
        return true
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
        resignTextFields()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
} // UITableViewController end
