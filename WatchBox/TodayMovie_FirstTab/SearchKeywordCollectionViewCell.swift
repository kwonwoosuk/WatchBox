//
//  SearchKeywordCollectionViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/30/25.
//

import UIKit
import SnapKit

final class SearchKeywordCollectionViewCell: BaseCollectionViewCell {
    
    static let id = "SearchKeywordCollectionViewCell"
    private let containerView = UIView()
    
    private let searchKeyword = UILabel()
    private let deleteButton = UIButton()
    var deleteButtonHandler: (() -> Void)?

    override func configureHierarchy() {
        contentView.addSubview(containerView)
        [searchKeyword, deleteButton].forEach{ containerView.addSubview($0) }
    }
    
    override func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
            make.height.equalTo(32)
        }
        
        searchKeyword.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalTo(searchKeyword.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        containerView.backgroundColor = .normalGray
        containerView.layer.cornerRadius = 15
        
        searchKeyword.font = .systemFont(ofSize: 14)
        searchKeyword.textColor = .black
        searchKeyword.textAlignment = .center
        
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        deleteButton.setTitleColor(.red, for: .highlighted)
        deleteButton.tintColor = .gray
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }

    @objc //  지우기 눌렀을때 서치 쿼리 가서 인덱스패스에 맞게 지워주기
    func deleteButtonTapped() {
        deleteButtonHandler?()
    }
    
    func configureKeyword(searchQuery: String) {
        searchKeyword.text = searchQuery
    }
}
