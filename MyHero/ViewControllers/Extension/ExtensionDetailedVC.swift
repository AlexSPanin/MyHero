//
//  ExtensionDetailedVC.swift
//  MyHero
//
//  Created by Александр Панин on 12.02.2022.
//

import UIKit

extension DetailedViewController {
    
    func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
    }
    
    func setupShareButton(width: CGFloat, heigth: CGFloat) {
        view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(shareDetails), for: .touchDown)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        shareButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
    }
    
    func setupZoomButton(width: CGFloat, heigth: CGFloat) {
        view.addSubview(zoomButton)
        zoomButton.addTarget(self, action: #selector(zoomImage), for: .touchDown)
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        zoomButton.heightAnchor.constraint(equalToConstant: heigth).isActive = true
        zoomButton.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        zoomButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
    }
    
    func setupImageScroll() {
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
    
    func setupDetailScroll() {
        
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
