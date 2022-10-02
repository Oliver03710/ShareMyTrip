//
//  RecommendationViewController.swift
//  ShareMyTrip
//
//  Created by Junhee Yoon on 2022/09/27.
//

import UIKit

import SnapKit
import PanModal

final class RecommendationViewController: BaseViewController {

    // MARK: - Properties

    private lazy var collectionView: CustomCollectionView = {
        let cv = CustomCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout(itemWidth: view.bounds.size.width / 1.5, itemHeight: view.bounds.height / 3, minimumLineSpacing: 16, minimumInteritemSpacing: 16, sectionInsetTop: 24, sectionInsetLeft: 16, sectionInsetBottom: 16, sectionInsetRight: 16), cellClass: RecommendationCollectionViewCell.self, forCellReuseIdentifier: RecommendationCollectionViewCell.reuseIdentifier, delegate: self)
        return cv
    }()
    
    private let titleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .bold, fontSize: 28, text: "목적지 근처 추천 관광지", textAlignment: .center)
        return label
    }()
    
    private let characterImageView: CharacterImageView = {
        let iv = CharacterImageView(.zero, image: CharacterImage.crying.rawValue, contentMode: .scaleAspectFit)
        iv.alpha = 0.5
        return iv
    }()
    
    private let bubbleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .heavy, fontSize: 20, text: "근처에 추천 관광지가 없습니다.")
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let viewModel = RecommendationsViewModel()
    var index = 0
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.isHidden = viewModel.touristAttractionsAnno.value.isEmpty ? true : false
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        viewModel.regionContainsAnno(index: index)
        setConstraints()
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        [characterImageView, bubbleLabel, titleLabel, collectionView].forEach { view.addSubview($0) }
        
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1)
            make.height.width.equalTo(200)
        }
        
        bubbleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.7)
            make.height.equalTo(20)
            make.width.equalTo(view.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        collectionView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
    }
    
    func collectionViewLayout(itemWidth: CGFloat, itemHeight: CGFloat, minimumLineSpacing: CGFloat, minimumInteritemSpacing: CGFloat, sectionInsetTop: CGFloat, sectionInsetLeft: CGFloat, sectionInsetBottom: CGFloat, sectionInsetRight: CGFloat) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.sectionInset = UIEdgeInsets(top: sectionInsetTop, left: sectionInsetLeft, bottom: sectionInsetBottom, right: sectionInsetRight)
        return layout
    }

}


// MARK: - Extension: UICollectionViewDelegate

extension RecommendationViewController: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}


// MARK: - Extension: UICollectionViewDataSource

extension RecommendationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.touristAttractionsAnno.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.reuseIdentifier, for: indexPath) as? RecommendationCollectionViewCell else { return UICollectionViewCell() }

        cell.setLabels(nameText: viewModel.touristAttractionsAnno.value[indexPath.item].name, addressText: viewModel.touristAttractionsAnno.value[indexPath.item].address, introductionText: viewModel.touristAttractionsAnno.value[indexPath.item].introduction, adminText: viewModel.touristAttractionsAnno.value[indexPath.item].admin, phoneNumText: viewModel.touristAttractionsAnno.value[indexPath.item].phoneNumber)

        return cell
    }
    
}


// MARK: - Extension: PanModalPresentable

extension RecommendationViewController: PanModalPresentable {

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
