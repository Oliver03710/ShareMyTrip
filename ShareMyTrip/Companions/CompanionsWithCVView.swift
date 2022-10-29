//
//  CompanionsWithCVView.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/10/25.
//

import UIKit

import SnapKit

final class CompanionsWithCVView: BaseView {

    // MARK: - Properties
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.companionImage.rawValue, contentMode: .scaleAspectFit)
        return iv
    }()
    
    let collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        viewModel.companions.value = TripHistoryRepository.standard.fetchTrips(.current)[0].companions
    }
}


// MARK: - Extension: Compositional Layout & DiffableDataSource

extension CompanionsWithCVView {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CompanionsCollectionViewCell, Companions> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.companion
            content.textProperties.font = .preferredFont(forTextStyle: .title3)
            cell.contentConfiguration = content
            
            cell.backgroundConfiguration = UIBackgroundConfiguration.listPlainCell()
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    func bindData() {
        viewModel.companions.bind { [unowned self] companion in
            let companions = companion.toArray()
            var snapshot = NSDiffableDataSourceSnapshot<Int, Companions>()
            snapshot.appendSections([0])
            snapshot.appendItems(companions)
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            let currentTrip = TripHistoryRepository.standard.fetchTrips(.current)
            self.collectionView.isHidden = companion.isEmpty ? true : false
        }
    }
}
