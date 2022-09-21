//
//  StartingViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import UIKit

final class StartingViewModel {
    
    // MARK: - Properties
    
    var nameText: Observable<String> = Observable("")
    var isValid: Observable<Bool> = Observable(false)

    
    // MARK: - Helper Functions
    
    func checkValidation() {
        let string = nameText.value.trimmingCharacters(in: .whitespaces)
        if nameText.value.isEmpty || string.isEmpty {
            isValid.value = false
        } else {
            isValid.value = true
        }
    }
    
    func transition(text: String, completion: @escaping () -> Void) {
        UserdefaultsHelper.standard.isTraveling = true
        UserdefaultsHelper.standard.tripName = text
        completion()
    }
    
    func activateButton(_ button: UIButton) {
        isValid.bind { bool in
            button.isEnabled = bool
            button.backgroundColor = bool ? .systemBrown : .lightGray
        }
    }
    
    func bindsTextField(_ textField: UITextField) {
        nameText.bind { text in
            textField.text = text
        }
    }
    
}
