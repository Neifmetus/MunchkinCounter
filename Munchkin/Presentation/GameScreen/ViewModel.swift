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
    func finishGame(winner: Int)
}

class ViewModel: ViewModelDelegate {
    var players: [Player] = []
    var maxId: Int {
        return players.map({ $0.id }).max() ?? 0
    }
    
    weak var delegate: ViewModelDelegate?
    
    func indexOf(id: Int) -> Int? {
        players.firstIndex(where: { $0.id == id })
    }
    
    func levelUp(id: Int) {
        for i in 0..<players.count {
            let player = players[i]
            if player.id == id {
                if player.level == 9 {
                    finishGame(winner: id)
                } else {
                    players[i].level += 1
                }
            }
        }
    }
    
    func levelDown(id: Int) {
        for i in 0..<players.count {
            let player = players[i]
            if player.id == id {
                players[i].level -= 1
            }
        }
    }
    
    func finishGame(winner: Int) {
        delegate?.finishGame(winner: winner)
    }
}
