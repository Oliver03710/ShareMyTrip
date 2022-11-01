//
//  CompanionViewModel.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/17.
//

import UIKit

import RealmSwift

final class CompanionViewModel {
    
    // MARK: - Properties
    
    var companions: Observable<List<Companions>> = Observable(List())
    
}
