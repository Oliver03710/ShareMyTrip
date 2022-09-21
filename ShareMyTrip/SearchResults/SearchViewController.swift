//
//  SearchViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/15.
//

import UIKit
import MapKit

import SnapKit
import Toast
import PanModal

final class SearchViewController: BaseViewController {

    // MARK: - Properties
    
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "어디로 가시나요?"
        sb.delegate = self
        return sb
    }()
    
    private lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier, delegate: self)
        return tv
    }()
    
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let sc = MKLocalSearchCompleter()
        sc.delegate = self
        return sc
    }()
    
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var onDoneBlock : ((Bool) -> Void)?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    
    // MARK: - Helper Functions
    
    override func setContraints() {
        [searchBar, tableView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }

}


// MARK: - Extension: UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CustomCGFloats.searchingView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                self.view.makeToast("위치정보를 받아오는데 오류가 발생하였습니다.")
                return
            }
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
            CurrentTripRepository.standard.addItem(name: result.title, address: result.subtitle, latitude: lat, longitude: lon, turn: CurrentTripRepository.standard.tasks.count + 1)
            CurrentTripRepository.standard.fetchRealmData()
            self.onDoneBlock?(true)
        }
        dismiss(animated: true)
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        let searchResult = searchResults[indexPath.row]
        cell.setCellComponents(title: searchResult.title, subTitle: searchResult.subtitle)
        
        return cell
    }
    
}


// MARK: - Extension: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        if let text = searchBar.text {
            tableView.isHidden = text.isEmpty ? true : false
        }
    }
    
}


// MARK: - Extension: MKLocalSearchCompleterDelegate

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
    
}


// MARK: - Extension: PanModalPresentable

extension SearchViewController: PanModalPresentable {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(UIScreen.main.bounds.height / 100)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}
