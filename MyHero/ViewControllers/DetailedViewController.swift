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
    
    private let fontNormal = UIFont(name: "Thonburi", size: 15)
    private let fontLarge = UIFont(name: "Thonburi", size: 25)
    private let colorFont: UIColor = .black
    private let colorBgrnd: UIColor = .white
    private let widthButton: CGFloat = 25
    private let heigthButton: CGFloat = 25
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = fontLarge
        label.textColor = colorFont
        label.backgroundColor = colorBgrnd
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(self, action: #selector(shareDetails), for: .touchDown)
        return button
    }()
    
    private let zoomButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(zoomImage), for: .touchDown)
        return button
    }()
    
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

extension DetailedViewController {
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
    }
    
    private func setupShareButton(width: CGFloat, heigth: CGFloat) {
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        shareButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        shareButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
    }
    
    private func setupZoomButton(width: CGFloat, heigth: CGFloat) {
        view.addSubview(zoomButton)
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        zoomButton.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        zoomButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        zoomButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
    }
    
    private func setupImageScroll() {
        let heigth = view.bounds.height / 2
        let cgRect = CGRect(
            x: 0,
            y: view.bounds.origin.y + 5,
            width: view.bounds.width,
            height: heigth)
        imageScroll = ImageScrollView(frame: cgRect)
        view.addSubview(imageScroll)
        
        imageScroll.translatesAutoresizingMaskIntoConstraints = false
        imageScroll.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        imageScroll.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
        imageScroll.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageScroll.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setupDetailScroll() {
        
        let heigth = view.bounds.height / 2
        let cgRect = CGRect(
            x: 0,
            y: imageScroll.bounds.height + 5,
            width: view.bounds.width,
            height: heigth)
        detailsScroll = DetailedScrollView(frame: cgRect)
        detailsScroll.isScrollEnabled = true
        detailsScroll.showsHorizontalScrollIndicator = false
        detailsScroll.showsLargeContentViewer = true
        
        view.addSubview(detailsScroll)
        
        detailsScroll.translatesAutoresizingMaskIntoConstraints = false
        
        detailsScroll.topAnchor.constraint(equalTo: imageScroll.bottomAnchor, constant: -1).isActive = true
        detailsScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        detailsScroll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        detailsScroll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
    }
}

