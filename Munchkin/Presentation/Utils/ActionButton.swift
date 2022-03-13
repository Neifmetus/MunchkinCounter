//
//  ActionButton.swift
//  Munchkin
//
//  Created by Neifmetus on 15.02.2022.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -16, dy: -16).contains(point)
    }
    
    private func setStyle() {
        self.layer.cornerRadius = 11
        self.backgroundColor = .mainLineColor
        self.setTitleColor(.white, for: .normal)
    }
    
}
