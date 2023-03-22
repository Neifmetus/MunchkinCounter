//
//  NewPlayerCell.swift
//  Munchkin
//
//  Created by Neifmetus on 16.01.2022.
//

import UIKit
import SnapKit

protocol NewPlayerCellDelegate: AnyObject {
    func addPlayer()
}

class NewPlayerCell: UICollectionViewCell {
    weak var delegate: NewPlayerCellDelegate?
    
    let backgroudView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackgroundColor
        view.layer.borderColor = UIColor.mainLineColor.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 25
        return view
    }()
    
    lazy var button: ActionButton = {
        let button = ActionButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(hasBeenTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: private
    private func layoutViews() {
        backgroudView.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(60)
        }
        
        contentView.addSubview(backgroudView)
        backgroudView.snp.makeConstraints { make in
            make.top.leading.equalTo(16)
            make.trailing.bottom.equalTo(-16)
        }
    }
    
    @objc
    private func hasBeenTapped() {
        delegate?.addPlayer()
    }
}
