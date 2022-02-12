//
//  DetailedViewController.swift
//  MyHero
//
//  Created by Александр Панин on 08.02.2022.
//

import UIKit

class DetailedViewController: UIViewController {
    
    var detailsScroll = DetailedScrollView()
    var imageScroll = ImageScrollView()
    
    var hero: Hero?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = fontLarge
        label.textColor = colorFont
        label.backgroundColor = colorBgrnd
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        
        return button
    }()
    
    let zoomButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        
        return button
    }()
    
    private let fontNormal = UIFont(name: "Thonburi", size: 15)
    private let fontLarge = UIFont(name: "Thonburi", size: 25)
    private let colorFont: UIColor = .black
    private let colorBgrnd: UIColor = .white
    private let widthButton: CGFloat = 25
    private let heigthButton: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let hero = hero else { return }
        nameLabel.text = hero.name
        self.detailsScroll.setDetails(hero: hero)
        self.imageScroll.setImage(hero: hero)
    }
    
    @objc func shareDetails() {
        guard let share = imageScroll.imageZoomView?.image else { return }
        let shareController = UIActivityViewController(activityItems: [share], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    @objc func zoomImage() {
        let cgPoint = CGPoint(x: imageScroll.center.x, y: imageScroll.center.y)
        imageScroll.zoomToTap(point: cgPoint, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = colorBgrnd
        setupNameLabel()
        setupImageScroll()
        setupShareButton(width: widthButton, heigth: heigthButton)
        setupZoomButton(width: widthButton, heigth: heigthButton)
        setupDetailScroll()
    }
}


