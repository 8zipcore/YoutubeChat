//
//  PlaylistViewController.swift
//  YoutubeChat
//
//  Created by 홍승아 on 7/3/24.
//

import UIKit

class PlaylistViewController: UIViewController {

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var titleLabel: SDGothicLabel!
    @IBOutlet weak var videoNumberLabel: SDGothicLabel!
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    var yPoint: CGFloat = 0
    
    var playlistViewModel = PlaylistViewModel()
    
    // test
    var array:[Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillLayoutSubviews() {
        self.view.frame = CGRectMake(0, yPoint, self.view.bounds.width, self.view.bounds.height - yPoint)
    }
    
    private func configureView(){
        titleLabel.setLabel(textColor: .black, fontSize: 18)
        videoNumberLabel.setLabel(textColor: Colors.gray, fontSize: 15)
        
        let nib = UINib(nibName: PlayListTableViewCell.identifier, bundle: nil)
        playlistTableView.register(nib, forCellReuseIdentifier: PlayListTableViewCell.identifier)
        
        playlistTableView.dataSource = self
        playlistTableView.delegate = self
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        self.topBarView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        let viewTranslation = sender.translation(in: self.view) // 이동한 위치
        let viewVelocity = sender.velocity(in: self.view) // 이동한 방향
        
        switch sender.state {
        case .began: 
            break
        case .changed: 
            if viewVelocity.y > 0 {
                UIView.animate(withDuration: 0.15){
                    self.view.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
                }
            }
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.2){
                    self.view.transform = .identity
                }
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                }, completion: {_ in
                    self.dismiss(animated: false)
                })
            }
        default:
        return
        }
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension PlaylistViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playlistTableView.dequeueReusableCell(withIdentifier: PlayListTableViewCell.identifier, for: indexPath) as? PlayListTableViewCell else {
            return UITableViewCell() }
        
        cell.setVideo(video: array[indexPath.item])
        
        return cell
    }
}

extension PlaylistViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 20
        let thumbnailImageViewWidth = self.view.bounds.width * 0.36
        return (thumbnailImageViewWidth * 9) / 16 + spacing
    }
}
