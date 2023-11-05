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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("maxLevel", comment: "")
        return label
    }()
    
    private lazy var field: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainLineColor
        return view
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let level = UserDefaults.standard.integer(forKey: "maxLevel")
        maxLevel = level == 0 ? 10 : level
        field.text = "\(maxLevel)"
        field.delegate = self
        cofigureLayout()
        addDoneButtonOnKeyboard()
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
        view.addSubview(lineView)
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(field)
            make.leading.equalToSuperview().offset(16)
        }
        
        field.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.centerX.equalTo(lineView)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(field.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.height.equalTo(2)
            make.width.equalTo(80)
        }
    }
    
    private func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("done", comment: ""),
                                                    style: .done,
                                                    target: self,
                                                    action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        field.inputAccessoryView = doneToolbar
    }

    @objc
    private func doneButtonAction() {
        field.resignFirstResponder()
        dismiss(animated: true)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
        }
    }
}
