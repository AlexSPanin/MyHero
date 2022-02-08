//
//  ImageHeroViewController.swift
//  MyHero
//
//  Created by Александр Панин on 26.01.2022.
//

import UIKit

class ImageHeroViewController: UIViewController {
    
    @IBOutlet var heroImageView: UIImageView!
    @IBOutlet var heroNameLabel: UILabel!
    
    var hero: Heros?
    
    private var imageURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heroNameLabel.text = hero?.hero.name
        imageURL = URL(string: hero?.hero.images.lg ?? "")
        updateImage()
    }
    
    func actionShareButton(_ sender: Any) {
        let image = heroImageView.image!
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool { print("Yes")}
        }
        present(shareController, animated: true, completion: nil)
        
    }
    // MARK: -  остановка аниматора загрузка и вывод картинки
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
    
    // MARK: - получение картинки из кэша
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        if let cacheImage = ImageCache.shared.object(forKey: ("lg" + url.lastPathComponent) as NSString) {
            completion(.success(cacheImage))
            return
        }
        NetworkingManager.shared.fetchImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                ImageCache.shared.setObject(image, forKey: ("lg" + url.lastPathComponent) as NSString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
