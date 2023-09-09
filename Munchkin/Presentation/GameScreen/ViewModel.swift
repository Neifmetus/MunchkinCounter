//
//  ViewModel.swift
//  Munchkin
//
//  Created by Neifmetus on 15.02.2022.
//

import Foundation

struct Player {
    var name = ""
    var level = 1
    let id: Int
    
    init(id: Int) {
        self.id = id
        self.name = "\(NSLocalizedString("player", comment: "")) \(id)"
    }
}

protocol ViewModelDelegate: AnyObject {
    func finishGame(winner: Int)
    func updateCell(with index: Int)
}

class ViewModel {
    var players: [Player] = []
    var maxId: Int {
        return players.map({ $0.id }).max() ?? 0
    }
    
    weak var delegate: ViewModelDelegate?
    
    var maxLevel: Int {
        let level = UserDefaults.standard.integer(forKey: "maxLevel")
        return level == 0 ? 10 : level
    }
    
    func indexOf(id: Int) -> Int? {
        players.firstIndex(where: { $0.id == id })
    }
    
    func levelUp(id: Int) {
        for i in 0..<players.count {
            let player = players[i]
            if player.id == id {
                if player.level == maxLevel - 1 {
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
    
    func updatePlayer(with playerId: Int, name: String) {
        if let index = players.firstIndex(where: { $0.id == playerId }) {
            players[index].name = name
            delegate?.updateCell(with: index)
        }
    }
    
    func finishGame(winner: Int) {
        delegate?.finishGame(winner: winner)
    }
}
