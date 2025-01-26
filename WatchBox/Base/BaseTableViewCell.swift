//
//  BaseTableViewCell.swift
//  WatchBox
//
//  Created by 권우석 on 1/26/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    
    
    @available(*,unavailable) //  * == 모든 플랫폼을 의미
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
}
