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
    
    var id: Int?
    var like: Bool = false
    var heros: Heros?
    
    var delegate: SuperHerosCollectionViewCellDelegate!
    
    
    // - кнопка понравившеяся картинка
    let likesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        return button
    }()
    
    // MARK: - переменная для проверки нахождения адреса картинки в кеш Cach Image
    private var imageURL: URL? {
        didSet {
            heroImageView.image = nil
            updateImage()
        }
    }
    
    // MARK: - функция для отработки выбора понравившейся картинки
    @objc func editLike() {
        like.toggle()
        heros?.like = like
        let image = like ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likesButton.setImage(image, for: .normal)
        delegate.button(for: self)
    }
    
    // MARK: -  функция конфигурирования ячейки в CollectionView
    func configure(_ hero: Heros) {
        heros = hero
        like = hero.like
        id = hero.hero.id
        heroNameLabel.text = hero.hero.name
        imageURL = URL(string: hero.hero.images.sm ?? "")
        
        setupLikesButton()
    }
    
    // MARK: - настройка параметров кнопки "понравилось"
    private func setupLikesButton() {
        addSubview(likesButton)
        let image = like ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likesButton.setImage(image, for: .normal)
        
        likesButton.topAnchor.constraint(equalTo: heroImageView.topAnchor, constant: 0).isActive = true
        likesButton.rightAnchor.constraint(equalTo: heroImageView.rightAnchor, constant: 0).isActive = true
        likesButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        likesButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        likesButton.addTarget(self, action: #selector(editLike), for: .touchDown)
    }
    
    // MARK: -  обновление картинки картинки
    private func updateImage() {
        guard let url = imageURL else { return }
        
        getImage(from: url){ result in
            switch result {
            case .success(let image):
                if url == self.imageURL {
                    self.heroImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - получение картинки из кэша либо загрузка из интернета
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        if let cacheImage = ImageCache.shared.object(forKey: ("sm" + url.lastPathComponent) as NSString) {
            completion(.success(cacheImage))
            return
        }
        NetworkingManager.shared.fetchImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                ImageCache.shared.setObject(image, forKey: ("sm" + url.lastPathComponent) as NSString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
