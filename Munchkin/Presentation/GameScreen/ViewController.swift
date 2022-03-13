//
//  ViewController.swift
//  Munchkin
//
//  Created by Neifmetus on 18.12.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: CGRect.zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(PlayerCell.self, forCellWithReuseIdentifier: "player_cell")
        collectionView.register(NewPlayerCell.self, forCellWithReuseIdentifier: "new_player_cell")
                
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.players.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < viewModel.players.count,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "player_cell",
                                                         for: indexPath) as? PlayerCell {
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(removePlayer))
            cell.addGestureRecognizer(longPressRecognizer)
            let id = viewModel.players[indexPath.row].id
            cell.playerId = id
            cell.setName("Игрок \(id)")
            cell.delegate = self
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "new_player_cell",
                                                                for: indexPath) as? NewPlayerCell {
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    @objc
    private func removePlayer(sender: UILongPressGestureRecognizer) {
        if let playerCell = sender.view as? PlayerCell {
            viewModel.players.removeAll(where: { $0.id == playerCell.playerId })
            collectionView.reloadData()
        }
    }
}

extension ViewController: NewPlayerCellDelegate {
    func addPlayer() {
        viewModel.players.append(Player(id: viewModel.maxId + 1))
        collectionView.reloadData()
    }
}

extension ViewController: PlayerCellDelegate {
    func levelUp(for id: Int) {
        
    }
    
    func levelDown(for id: Int) {
    
    }
    
    func finishGame() {
        let alert = UIAlertController(title: "Перезагрузить игру",
                                      message: nil,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .default, handler: { _ in }))
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.viewModel.players = []
            self?.collectionView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
