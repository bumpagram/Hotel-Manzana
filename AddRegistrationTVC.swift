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
    
    
    let checkinDatePickerIndexPath = IndexPath(row: 1, section: 1)  // 1:1 это сам DatePicker
    let checkoutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    let checkinLabelCellIndexPath = IndexPath(row: 0, section: 1)  // а мы тыкаем на лейбл-заголовок ячейкой выше
    let checkOutLabelCellIndexPath = IndexPath(row: 2, section: 1)  // аналогично

    
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
    }
    
    
    @IBAction func keyboardHide(_ sender: UITapGestureRecognizer) {
        // странно, не работает
//        self.firstNameField.resignFirstResponder()
//        self.lastNameField.resignFirstResponder()
//        self.emailField.resignFirstResponder()
    }
    @IBAction func datePickerValueChanged(_ sender: Any) {
        updateDateViews()
    }
    @IBAction func steppersValueChanged(_ sender: UIStepper) {
        updateNumbers()
        checkUserInputStatus()
    }
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        // implement чуть позже
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func userTappedAnyButton(_ sender: UITextField) { 
        // экшен на проверку корректности текстового ввода переадресует в функцию с логикой
        checkUserInputStatus()
    }
    @IBAction func unwindToAddRegistration(segue: UIStoryboardSegue) {
        // Подключен,но xcode кружок не закрасил
        checkUserInputStatus()
    }
    
    
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTVC? {
        let selectRoomController = SelectRoomTypeTVC(coder: coder)  // инициализируем ViewController и кладем его в константу
        selectRoomController?.delegatee = self  // на AddRegistrationTVC
        selectRoomController?.currentlySelectedRoomType = roomType
        return selectRoomController
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
    
    func updateRooms() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.shortName
        } else {
            roomTypeLabel.text = "Not set"
        }
    }
    
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTVC, didSelect roomType: RoomType) { 
        // метод протокола требуется имплементировать
        self.roomType = roomType
        updateRooms()
    }
    
    func checkUserInputStatus() {
        doneButton.isEnabled = false // по умолчанию кнопка Done выключена пока не заполнены правильно все поля
        
        guard let _ = firstNameField.text, let _ = lastNameField.text, let _ = emailField.text else {return} //проверка на нил, не выделяем память на константы
        guard firstNameField.text != "", lastNameField.text != "", emailField.text != "" else {return}
        guard !emailField.text!.contains(" "), emailField.text!.contains("@") else {return} // без пробелов емейле, но содержит собаку
        guard numberAdultsLabel.text != "0" else {return}
        guard roomType != nil else {return}
        doneButton.isEnabled = true
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
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
} // UITableViewController end
