//
//  ViewController.swift
//  Munchkin
//
//  Created by Neifmetus on 18.12.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let viewModel = ViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect.zero,
                           collectionViewLayout: UICollectionViewFlowLayout.init())
        view.keyboardDismissMode = .onDrag
        view.register(PlayerCell.self, forCellWithReuseIdentifier: "player_cell")
        view.register(NewPlayerCell.self, forCellWithReuseIdentifier: "new_player_cell")
        return view
    }()
    
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
    
    private lazy var escapeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dices"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(showEscapeRollView), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.delegate = self
        addSettingsButton()
        
        let width = UIScreen.main.bounds.width / 2
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setConstraints()
    }
    
    private func setConstraints() {
        let margins = view.layoutMarginsGuide
        view.addSubview(refreshButton)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -16),
            refreshButton.heightAnchor.constraint(equalToConstant: 50),
            refreshButton.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        view.addSubview(escapeButton)
        escapeButton.snp.makeConstraints { make in
            make.centerY.equalTo(refreshButton)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(50)
        }
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(refreshButton.snp.top).offset(-16)
        }
    }
    
    private func addSettingsButton() {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
        button.frame = CGRectMake(0, 0, 50, 50)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc private func settingsTapped() {
        let controller = SettingsViewController()
        if let sheet = controller.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(controller, animated: true, completion: nil)
    }
    
    @objc private func showEscapeRollView() {
        showMyViewControllerInACustomizedSheet()
    }
    
    func showMyViewControllerInACustomizedSheet() {
        let viewControllerToPresent = EscapeViewController()
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(viewControllerToPresent, animated: true, completion: nil)
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
            cell.setName(player.name)
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
    func changeName(playerId: Int, oldName: String) {
        let alert = UIAlertController(title: NSLocalizedString("changeName", comment: ""),
                                      message:  NSLocalizedString("enterName", comment: ""),
                                      preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = ""
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert, weak self] (_) in
            if let text = alert?.textFields?.first?.text, !text.isEmpty {
                self?.viewModel.updatePlayer(with: playerId, name: text)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { _ in }))

        self.present(alert, animated: true)
    }
    
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
    func updateCell(with index: Int) {
        collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
    }
    
    func finishGame(winner: Int) {
        let name = viewModel.players.first(where: { $0.id == winner })?.name ?? ""
        let title = String(format: NSLocalizedString(NSLocalizedString("winMessage", comment: ""), comment: ""), "\(name)")
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
