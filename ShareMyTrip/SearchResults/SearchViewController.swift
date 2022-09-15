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

class SearchViewController: BaseViewController {

    // MARK: - Properties
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "어디로 가시나요?"
        sb.delegate = self
        return sb
    }()
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var onDoneBlock : ((Bool) -> Void)?
    var mapViewModel: MapViewModel?
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func configureUI() {
        [searchBar, tableView].forEach { view.addSubview($0) }
        setSearchCompleter()
    }
    
    override func setContraints() {
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func setSearchCompleter() {
        searchCompleter.delegate = self
    }

}


// MARK: - Extension: UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            print(response ?? "response Error")
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                self.view.makeToast("위치정보를 받아오는데 오류가 발생하였습니다.")
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                self.view.makeToast("이름을 받아오는데 오류가 발생하였습니다.")
                return
            }
            
            print(name)
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
            print(lat)
            print(lon)
            
            self.mapViewModel?.location.value = CLLocationCoordinate2D(latitude: lat, longitude: lon)
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
    }
    
}


// MARK: - Extension: MKLocalSearchCompleterDelegate

extension SearchViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.view.makeToast("\(error.localizedDescription)")
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
