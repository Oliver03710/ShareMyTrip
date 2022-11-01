//
//  CompanionsWithCVView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/25.
//

import UIKit

import RealmSwift
import SnapKit

final class CompanionsWithCVView: BaseView {

    // MARK: - Properties
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.companionImage.rawValue, contentMode: .scaleAspectFit)
        return iv
    }()
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return cv
    }()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Companions>!
    let viewModel = CompanionViewModel()
    
    
    // MARK: - Init
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        initialFetchData()
        configureDataSource()
        bindData()
    }
    
    override func setConstraints() {
        [characterImageView, collectionView].forEach { self.addSubview($0) }
        
        characterImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func initialFetchData() {
        if let data = TripHistoryRepository.standard.fetchTrips(.current).first?.companions {
            viewModel.companions.value = data
        }
    }
}


// MARK: - Extension: Compositional Layout & DiffableDataSource

extension CompanionsWithCVView {
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] (indexPath) in
            guard let self = self else { return UISwipeActionsConfiguration() }
            guard let item = self.dataSource.itemIdentifier(for: indexPath) else { return UISwipeActionsConfiguration() }
            return self.trailingSwipeActionConfigurationForListCellItem(item)
        }
        configuration.backgroundColor = .white
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CompanionsCollectionViewCell, Companions> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.companion
            content.textProperties.font = .preferredFont(forTextStyle: .body)
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = #colorLiteral(red: 1, green: 0.9450980392, blue: 0.8431372549, alpha: 1)
            cell.backgroundConfiguration = background
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func trailingSwipeActionConfigurationForListCellItem(_ item: Companions) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {
            [weak self] (_, _, _) in
            guard let self = self else { return }
            
            TripHistoryRepository.standard.fetchRealmData()
            var check = Array<Companions>()
            TripHistoryRepository.standard.fetchTrips(.history).forEach { $0.companions.contains(item) ? check.append(item) : nil }
            if !check.isEmpty {
                TripHistoryRepository.standard.deleteCompanionItem(item: item, isContained: item)
            } else {
                TripHistoryRepository.standard.willDeleteItem(item: item)
            }
            guard let data = TripHistoryRepository.standard.fetchTrips(.current).first?.companions else { return }
            self.viewModel.companions.value = data
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func bindData() {
        viewModel.companions.bind { [weak self] companion in
            let companions = companion.where { $0.isbeingDeleted == false }.toArray()
            var snapshot = NSDiffableDataSourceSnapshot<Int, Companions>()
            snapshot.appendSections([0])
            snapshot.appendItems(companions)
            self?.dataSource.apply(snapshot, animatingDifferences: true)
            if !companion.where({ $0.isbeingDeleted == true }).isEmpty {
                companion.where { $0.isbeingDeleted == true }.forEach { TripHistoryRepository.standard.deleteCompanionItem(item: $0) }
            }
            
            self?.collectionView.isHidden = companion.isEmpty ? true : false
        }
    }
}
