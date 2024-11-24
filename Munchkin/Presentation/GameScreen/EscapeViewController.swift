//
//  EscapeViewController.swift
//  Munchkin
//
//  Created by Екатерина Батеева on 16.07.2023.
//

import UIKit

class EscapeViewController: UIViewController {
    private lazy var diceView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "dice1")
        return view
    }()
    
    private lazy var rollButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainBackgroundColor
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.setTitleColor(.mainLineColor, for: .normal)
        button.setTitle("\(NSLocalizedString("roll", comment: ""))", for: .normal)
        button.addTarget(self, action: #selector(roll), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(roll), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(rollButton)
        rollButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(32)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        
        view.addSubview(diceView)
        diceView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.bottom.equalTo(rollButton.snp.top).offset(-64)
            make.width.equalTo(diceView.snp.height)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.edges.equalTo(diceView)
        }
    }
    
    @objc
    private func roll() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(with: diceView, duration: 1.0, options: transitionOptions, animations: {
            self.diceView.isHidden = true
        })

        UIView.transition(with: diceView, duration: 1.0, options: transitionOptions, animations: {
            self.diceView.isHidden = false
            let random = Int.random(in: 1...6)
            self.diceView.image = UIImage(named: "dice\(random)")
        })
    }

}
