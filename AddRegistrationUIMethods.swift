//  DetailsScreen.swift
//  Hotel Manzana
//  Created by .b[u]mpagram on 9/10/23.

///   Extension - вынес методы взаимодействия с UI  из основного класса все что смог

import UIKit
import Foundation

extension AddRegistrationTVC {
    
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
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not set"
        }
    }
    
    
    func updateCharges() {   // видимость ячеек счета и их логика
     
        let daysInHotel = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date).day!    // force unwrap тк в пикерах прописана логика и всегда будет минимум 1 день разницы
        numberSelectedNightsLabel.text = String(daysInHotel)
        detailsSelectedNightsLabel.text = checkInDateLabel.text! + " - " + checkOutDateLabel.text!
        
        if wifiSwitch.isOn {
         selectedWifiCell.isHidden = false
            totalWifiCost = daysInHotel * 10
            costWifi.text = "$ " + String(totalWifiCost)
        } else {
            selectedWifiCell.isHidden = true
            costWifi.text = "0"
            totalWifiCost = 0
        }
        if roomType == nil {
            selectedRoomsCell.isHidden = true
            totalRoomsCost = 0
        } else {
            selectedRoomsCell.isHidden = false
            totalRoomsCost = roomType!.price * daysInHotel
            costSelectedRoomLabel.text = "$ \(totalRoomsCost)"
            detailsSelectedRoomLabel.text = "\(roomType!.shortName) at $\(roomType!.price)/night"
        }
        totalCheckoutLabel.text = "$ " + String(totalCheckoutForGuest)
    }
    
    
    func resignTextFields() {
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
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
    
    
    
} // Extension end
