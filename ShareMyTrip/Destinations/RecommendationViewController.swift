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

    lazy var tableView: BaseTableView = {
        let tv = BaseTableView(frame: .zero, style: .insetGrouped, cellClass: RecommendationTableViewCell.self, forCellReuseIdentifier: RecommendationTableViewCell.reuseIdentifier, delegate: self)
        tv.backgroundColor = .white
        tv.estimatedRowHeight = 300
        return tv
    }()
    
    private let titleLabel: BaseLabel = {
        let label = BaseLabel(boldStyle: .bold, fontSize: 20, text: "목적지 근처 추천 관광지", textAlignment: .center)
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
        tableView.isHidden = viewModel.touristAttractionsAnno.value.isEmpty ? true : false
    }
    
    
    // MARK: - Helper Functions
    
    override func configureUI() {
        viewModel.regionContainsAnno(index: index)
        setConstraints()
        view.backgroundColor = .white
    }
    
    func setConstraints() {
        [characterImageView, bubbleLabel, titleLabel, tableView].forEach { view.addSubview($0) }
        
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
        
        tableView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
    }

}


// MARK: - Extension: UITableViewDelegate

extension RecommendationViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.touristAttractionsAnno.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


// MARK: - Extension: UITableViewDataSource

extension RecommendationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationTableViewCell.reuseIdentifier, for: indexPath) as? RecommendationTableViewCell else { return UITableViewCell() }
        
        cell.setLabels(nameText: viewModel.touristAttractionsAnno.value[indexPath.section].name, addressText: viewModel.touristAttractionsAnno.value[indexPath.section].address, introductionText: viewModel.touristAttractionsAnno.value[indexPath.section].introduction, phoneNumText: viewModel.touristAttractionsAnno.value[indexPath.section].phoneNumber)

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
