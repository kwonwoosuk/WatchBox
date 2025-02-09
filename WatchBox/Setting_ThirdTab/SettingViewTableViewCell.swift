//
//  SettingViewTableViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/28/25.
//

import UIKit
import SnapKit

final class SettingViewTableViewCell: BaseTableViewCell {

    static let id = "SettingViewTableViewCell"
    let settingMenuLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(settingMenuLabel)
    }
    
    override func configureLayout() {
        settingMenuLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    override func configureView() {
        settingMenuLabel.font = .systemFont(ofSize: 14)
        settingMenuLabel.textColor = .white
        settingMenuLabel.textAlignment = .left
        backgroundColor = .clear
    }
    
    
}
