//  DetailsScreen.swift
//  Hotel Manzana
//  Created by .b[u]mpagram on 9/10/23.

// Это extension для AddRegistration TableVeiwController.
// Класс тот же, дописываю нужные методы, кодом переверстаю части экрана, чтобы отображалось не модально, а в горизонтальной навигации экрана типа "Детали"
//
import UIKit
import Foundation

extension AddRegistrationTVC {
    
    static var fromTappedCellToDetails: Bool = false  // флаг для контроля прихода сигвея
    
    func presentAsDetails() {
        print("got details func event")
        
        doneButton.isHidden = true
        cancelButton.isHidden = true
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = "Registration Details"
        self.navigationItem.style = .editor
        //self.navigationItem.leftBarButtonItem =
        
        
    }
    
    
    

    
    
}  // Extension end


