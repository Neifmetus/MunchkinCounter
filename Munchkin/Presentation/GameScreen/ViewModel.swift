//
//  ViewModel.swift
//  Munchkin
//
//  Created by Neifmetus on 15.02.2022.
//

struct Player {
    var name = ""
    var level = 0
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

protocol ViewModelDelegate: AnyObject {
    func finishGame()
}

class ViewModel: ViewModelDelegate {
    func finishGame() {
    }
    
    var players: [Player] = []
    var maxId: Int {
        return players.map({ $0.id }).max() ?? 0
    }
    
    weak var delegate: ViewModelDelegate?
    
    func levelUp(id: Int) {
        players.forEach {
            if $0.id == id {
                if $0.level < 9 {
                    //$0.level = $0.level + 1
                } else if $0.level == 9 {
                    //$0.level = $0.level + 1
                    delegate?.finishGame()
                }
            }
        }
    }
}
