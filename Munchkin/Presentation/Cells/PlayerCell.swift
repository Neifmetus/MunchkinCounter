//
//  PlayerCell.swift
//  Munchkin
//
//  Created by Neifmetus on 16.01.2022.
//

import UIKit
import SnapKit

protocol PlayerCellDelegate: AnyObject {
    func levelUp(for id: Int)
    func levelDown(for id: Int)
}

class PlayerCell: UICollectionViewCell {
    
    var playerId: Int = 0
    weak var delegate: PlayerCellDelegate?
    
    private let backgroudView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackgroundColor
        view.layer.borderColor = UIColor.mainLineColor.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 25
        view.accessibilityIdentifier = "test"
        return view
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        return nameLabel
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLineColor
        return view
    }()
    
    private let levelCounterView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondBackgroundColor
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let levelCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let minusButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(decreaseLevel), for: .touchUpInside)
        button.accessibilityIdentifier = "minus_button"
        return button
    }()
    
    private let plusButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(increaseLevel), for: .touchUpInside)
        button.accessibilityIdentifier = "plus_button"
        return button
    }()
    
    private var actualLevel: Int = 0 {
        didSet {
            levelCountLabel.text = "\(actualLevel)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLevel(_ level: Int) {
        levelCountLabel.text = "\(level)"
    }
    
    func setName(_ name: String) {
        nameLabel.text = "\(name)"
    }
    
    //MARK: private
    private func layoutViews() {
        backgroudView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
        }

        backgroudView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.height.equalTo(1)
        }

        backgroudView.addSubview(levelCounterView)
        levelCounterView.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(78)
        }

        levelCounterView.addSubview(levelCountLabel)
        levelCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        backgroudView.addSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(levelCounterView.snp.centerY)
            make.trailing.equalTo(levelCounterView.snp.leading).offset(-14)
            make.height.width.equalTo(22)
        }

        backgroudView.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(levelCounterView.snp.centerY)
            make.leading.equalTo(levelCounterView.snp.trailing).offset(14)
            make.height.width.equalTo(22)
        }
        
        contentView.addSubview(backgroudView)
        backgroudView.snp.makeConstraints { make in
            make.top.leading.equalTo(16)
            make.trailing.bottom.equalTo(-16)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
    }
    
    @objc
    private func decreaseLevel() {
        delegate?.levelDown(for: playerId)
    }
    
    @objc
    private func increaseLevel() {
        delegate?.levelUp(for: playerId)
    }
}
