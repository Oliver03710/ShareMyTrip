//
//  SearchViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/15.
//

import UIKit
import MapKit

import RealmSwift
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
    
    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .plain, cellClass: SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reuseIdentifier, delegate: self)
        tv.prefetchDataSource = self
        return tv
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.searchImage.rawValue, contentMode: .scaleAspectFit)
        return iv
    }()
    
//    private lazy var searchCompleter: MKLocalSearchCompleter = {
//        let sc = MKLocalSearchCompleter()
//        sc.delegate = self
//        return sc
//    }()
    
//    private var searchResults = [MKLocalSearchCompletion]() {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    var onDoneBlock : ((Bool) -> Void)?
    var showToast : (() -> Void)?
    let viewModel = SearchViewModel()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        view.backgroundColor = .systemBackground
        viewModel.reloadTableView(tableView)
    }
    
    override func setConstraints() {
        [characterImageView, searchBar, tableView].forEach { view.addSubview($0) }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

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
        
        TripHistoryRepository.standard.fetchRealmData()
        let currentTrip = TripHistoryRepository.standard.tasks.where { $0.isTraveling == true }
        if currentTrip[0].trips.count < 50 {
            let task = CurrentTrip(name: viewModel.results.value[indexPath.row].name, address: viewModel.results.value[indexPath.row].address, latitude: viewModel.results.value[indexPath.row].coordinates.latitude, longitude: viewModel.results.value[indexPath.row].coordinates.longitude, turn: currentTrip[0].trips.count + 1)
            TripHistoryRepository.standard.updateItem(trip: task)
            self.onDoneBlock?(true)
        } else {
            self.showToast?()
            self.view.makeToast("더 이상 목적지를 추가할 수 없습니다.")
        }
        dismiss(animated: true)
    }
   

        // 애플 내장 지도 검색 기능
        
//        let result = searchResults[indexPath.row]
//        let searchRequest = MKLocalSearch.Request(completion: result)
//
//        let search = MKLocalSearch(request: searchRequest)
//        search.start { (response, error) in
//
//            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
//                self.view.makeToast("위치정보를 받아오는데 오류가 발생하였습니다.")
//                return
//            }
//
//            let lat = coordinate.latitude
//            let lon = coordinate.longitude
//
//
//            TripHistoryRepository.standard.fetchRealmData()
//            let currentTrip = TripHistoryRepository.standard.tasks.where { $0.isTraveling == true }
//            if currentTrip[0].trips.count < 50 {
//                let task = CurrentTrip(name: result.title, address: result.subtitle, latitude: lat, longitude: lon, turn: currentTrip[0].trips.count + 1)
//                TripHistoryRepository.standard.updateItem(trip: task)
//                self.onDoneBlock?(true)
//            } else {
//                self.showToast?()
//                self.view.makeToast("더 이상 목적지를 추가할 수 없습니다.")
//            }
//        }
//        dismiss(animated: true)
    
}


// MARK: - Extension: UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.results.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        
        let searchResult = viewModel.results.value[indexPath.row]
        cell.setCellComponents(title: searchResult.name, subTitle: searchResult.address)
        
        return cell
    }
    
}


// MARK: - Extension: UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.results.value.removeAll()
        viewModel.pages.value = 1
        guard let text = searchBar.text else { return }
        viewModel.searchText.value = text
        viewModel.requestAPI(viewModel.searchText.value, pages: viewModel.pages.value)
    }
    
}


// MARK: - Extension: MKLocalSearchCompleterDelegate

//extension SearchViewController: MKLocalSearchCompleterDelegate {
//
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        searchResults = completer.results
//    }
//
//}


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


// MARK: - Extension: UICollectionViewDataSourcePrefetching

extension SearchViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        indexPaths.forEach { indexPath in
            
            if viewModel.results.value.count - 7 == indexPath.row, viewModel.results.value.count < viewModel.totalCounts.value {
                viewModel.pages.value += 1
                print(viewModel.pages.value)
                viewModel.requestAPI(viewModel.searchText.value, pages: viewModel.pages.value)
            }
        }
    }
}
