//
//  SettingsViewController.swift
//  Munchkin
//
//  Created by Екатерина Батеева on 19.08.2023.
//

import SnapKit

protocol SettingsViewDelegate: AnyObject {
    func updateInfo()
}

class SettingsViewController: UIViewController {
    
    var maxLevel = 10
    weak var delegate: SettingsViewDelegate?
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("maxLevel", comment: "")
        return label
    }()
    
    private var field: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let level = UserDefaults.standard.integer(forKey: "maxLevel")
        maxLevel = level == 0 ? 10 : level
        field.text = "\(maxLevel)"
        cofigureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let text = field.text, !text.isEmpty {
            UserDefaults.standard.setValue(field.text, forKey: "maxLevel")
            delegate?.updateInfo()
        }
    }
    
    private func cofigureLayout() {
        view.addSubview(titleLabel)
        view.addSubview(field)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.leading.equalToSuperview().offset(16)
        }
        
        field.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.centerY.equalTo(titleLabel)
        }
    }
}
