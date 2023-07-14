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
    func deletePlayer(with id: Int)
    func changeName(playerId: Int, oldName: String)
}

class PlayerCell: UICollectionViewCell {
    
    var playerId: Int = 0
    weak var delegate: PlayerCellDelegate?
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.textColor = .mainLineColor
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
        label.text = "1"
        label.textColor = .mainLineColor
        label.accessibilityIdentifier = "level"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private lazy var minusButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("-", for: .normal)
        button.addTarget(self, action: #selector(decreaseLevel), for: .touchUpInside)
        button.accessibilityIdentifier = "minus_button"
        return button
    }()
    
    private lazy var plusButton: ActionButton = {
        let button = ActionButton()
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(increaseLevel), for: .touchUpInside)
        button.accessibilityIdentifier = "plus_button"
        return button
    }()
    
    private let backgroudView: UIButton = {
        let view = UIButton()
        view.backgroundColor = .mainBackgroundColor
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 25
        view.accessibilityIdentifier = "test"
        return view
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        let origImage = UIImage(systemName: "minus.circle")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .red
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private var actualLevel: Int = 1 {
        didSet {
            levelCountLabel.text = "\(actualLevel)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layoutViews()
        let contextMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("changeName", comment: ""), handler: { [weak self] action in
                guard let self = self, let name = self.nameLabel.text else { return }
                self.delegate?.changeName(playerId: self.playerId, oldName: name)
            }),
        ])

        backgroudView.menu = contextMenu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLevel(_ level: Int) {
        actualLevel = level
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
        }
        
        contentView.addSubview(removeButton)
        removeButton.snp.makeConstraints { make in
            make.centerX.equalTo(backgroudView.snp.trailing).inset(6)
            make.centerY.equalTo(backgroudView.snp.top).inset(6)
            make.size.equalTo(40)
        }
    }
    
    @objc
    private func buttonTapped() {
        delegate?.deletePlayer(with: playerId)
    }
    
    @objc
    private func decreaseLevel() {
        if actualLevel > 1 {
            actualLevel -= 1
            delegate?.levelDown(for: playerId)
        }
    }
    
    @objc
    private func increaseLevel() {
        actualLevel += 1
        delegate?.levelUp(for: playerId)
    }
}
