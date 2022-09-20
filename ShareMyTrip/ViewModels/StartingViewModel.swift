//
//  StartingViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/20.
//

import Foundation

final class StartingViewModel {
    
    // MARK: - Properties
    
    var nameText: Observable<String> = Observable("")
    var isValid: Observable<Bool> = Observable(false)

    
    // MARK: - Helper Functions
    
    func checkValidation() {
        isValid.value = nameText.value.isEmpty ? false : true
    }
    
    func transition(text: String, completion: @escaping () -> Void) {
        UserdefaultsHelper.standard.isTraveling = true
        UserdefaultsHelper.standard.tripName = text
        completion()
    }
    
}
