//
//  ViewController.swift
//  Munchkin
//
//  Created by Neifmetus on 18.12.2021.
//

import UIKit

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    
    private lazy var collectionView = UICollectionView(frame: CGRect.zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout.init())
    private lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainBackgroundColor
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.setTitleColor(.mainLineColor, for: .normal)
        button.setTitle("\(NSLocalizedString("restartGame", comment: ""))", for: .normal)
        button.addTarget(self, action: #selector(reloadGame), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        let width = (UIScreen.main.bounds.width - 48) / 2
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
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
        
        let margins = view.layoutMarginsGuide
        view.addSubview(refreshButton)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -16),
            refreshButton.heightAnchor.constraint(equalToConstant: 50),
            refreshButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.players.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < viewModel.players.count,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "player_cell",
                                                         for: indexPath) as? PlayerCell {
            let player = viewModel.players[indexPath.row]
            cell.playerId = player.id
            cell.setLevel(player.level)
            cell.setName("\(NSLocalizedString("player", comment: "")) \(player.id)")
            cell.delegate = self
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "new_player_cell",
                                                                for: indexPath) as? NewPlayerCell {
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ViewController: NewPlayerCellDelegate {
    func addPlayer() {
        let id = viewModel.players.count
        viewModel.players.append(Player(id: viewModel.maxId + 1))
        collectionView.insertItems(at: [IndexPath(row: id, section: 0)])
    }
}

extension ViewController: PlayerCellDelegate {
    func deletePlayer(with id: Int) {
        for cell in collectionView.visibleCells {
            if let cell = cell as? PlayerCell,
                cell.playerId == id,
                let index = viewModel.indexOf(id: id) {
                collectionView.performBatchUpdates({ [collectionView, viewModel] in
                    collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                    viewModel.players.removeAll(where: { $0.id == id })
                }) { [collectionView] (finished) in
                    collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                }
            }
        }
    }
    
    func levelUp(for id: Int) {
        viewModel.levelUp(id: id)
    }
    
    func levelDown(for id: Int) {
        viewModel.levelDown(id: id)
    }
}

extension ViewController: ViewModelDelegate {
    func finishGame(winner: Int) {
        let title = String(format: NSLocalizedString(NSLocalizedString("winMessage", comment: ""), comment: ""), "\(winner)")
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.reloadGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func reloadGame() {
        viewModel.players = []
        collectionView.reloadData()
    }
}
