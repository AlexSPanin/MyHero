//
//  DetailedScrollView.swift
//  MyHero
//
//  Created by Александр Панин on 08.02.2022.
//

import UIKit

class DetailedScrollView: UIScrollView {
    
    let fontNormal = UIFont(name: "Thonburi", size: 12)
    let fontLarge = UIFont(name: "Thonburi", size: 25)
    let colorFont: UIColor = .black
    let colorBgrnd: UIColor = .white
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = fontLarge
        label.textColor = colorFont
        label.backgroundColor = colorBgrnd
        return label
    }()
    lazy var powerstates: UILabel = {
        let label = UILabel()
        label.font = fontNormal
        label.textColor = colorFont
        label.backgroundColor = colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var appearance: UILabel = {
        let label = UILabel()
        label.font = fontNormal
        label.textColor = colorFont
        label.backgroundColor = colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var biography: UILabel = {
        let label = UILabel()
        label.font = fontNormal
        label.textColor = colorFont
        label.backgroundColor = colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var work: UILabel = {
        let label = UILabel()
        label.font = fontNormal
        label.textColor = colorFont
        label.backgroundColor = colorBgrnd
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - обновление интерфейса
    override func layoutSubviews() {
        super.layoutSubviews()
        configurate()
    }
    
    func setDetails(hero: Hero) {
        
        powerstates.text = hero.powerstatesLabel
        appearance.text = hero.appearanceLabel
        biography.text = hero.biographyLabel
        work.text = hero.workLabel
        
        configurate()
    }
}

extension DetailedScrollView {
    private func configurate() {
        
        let stackPowApp = UIStackView(arrangedSubviews: [powerstates, appearance])
        stackPowApp.axis = .horizontal
        stackPowApp.spacing = 10
        stackPowApp.distribution = UIStackView.Distribution.fill
        
        let stack = UIStackView(arrangedSubviews: [biography, work, stackPowApp])
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = UIStackView.Distribution.fill
        
        self.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
