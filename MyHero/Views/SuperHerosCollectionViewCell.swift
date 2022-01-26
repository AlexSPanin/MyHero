//
//  SuperHerosCollectionViewCell.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import UIKit

class SuperHerosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var heroImageView: UIImageView! {
        didSet {
            heroImageView.layer.cornerRadius = 15
        }
    }
    
    // MARK: - Cach Image
    
    private var imageURL: URL? {
        didSet {
            heroImageView.image = nil
            updateImage()
        }
    }
    
    private var activityIndicator: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator = showSpinner(in: heroImageView)
    }
    
    func configure(_ hero: Hero) {
        heroNameLabel.text = hero.name
        imageURL = URL(string: hero.images.sm ?? "")
        }
    
    
private func updateImage() {
    guard let url = imageURL else { return }
    NetworkingManager.shared.fetchImage(url: url ) { result in
        switch result {
        case .success(let data):
            if url == self.imageURL {
            self.activityIndicator?.stopAnimating()
            self.heroImageView.image = UIImage(data: data)
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
    
    // MARK: -  индикатор загрузки ввиде ромашки
    private func showSpinner( in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        return activityIndicator
    }
}
