//
//  SuperHerosCollectionViewCell.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import UIKit

class SuperHerosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var heroNameLabel: UILabel!
    @IBOutlet var heroImageView: UIImageView!
    
    func configure(_ hero: Hero) {
//        guard let hero = hero else { return }
        heroNameLabel.text = hero.name
        
        NetworkingManager.shared.fetchImage(url: hero.images.sm ?? "" ) { result in
            switch result {
                
            case .success(let data):
                self.heroImageView.image = UIImage(data: data)
                self.heroImageView.layer.cornerRadius = 15
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
