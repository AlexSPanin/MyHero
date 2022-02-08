//
//  SuperHeros.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import Foundation

struct Heros: Codable {
    var like: Bool = false
    let hero: Hero
}

// MARK: - Hero
struct Hero: Codable {
    let id: Int?
    let name: String?
    let slug: String?
    let powerstats: Powerstats
    let appearance: Appearance
    let biography: Biography
    let work: Work
    let connections: Connections
    let images: Images
    var powerstatesLabel: String { """
        Experience Characteristics:
        
        intelligence - \(powerstats.intelligence ?? 0)
        strength     - \(powerstats.strength ?? 0)
        speed        - \(powerstats.speed ?? 0)
        durability   - \(powerstats.durability ?? 0)
        power        - \(powerstats.power ?? 0)
        combat       - \(powerstats.combat ?? 0)
        """
    }
}

// MARK: - Powerstats
struct Powerstats: Codable {
    let intelligence, strength, speed, durability, power, combat: Int?
}

// MARK: - Appearance
struct Appearance: Codable {
    let gender, race: String?
    let height, weight: [String]?
    let eyeColor, hairColor: String?
}

// MARK: - Biography
struct Biography: Codable {
    let fullName, alterEgos: String?
    let aliases: [String]?
    let placeOfBirth, firstAppearance, publisher, alignment: String?
}

// MARK: - Work
struct Work: Codable {
    let occupation, base: String?
}

//MARK: - Connections
struct Connections: Codable {
    let groupAffiliation, relative: String?
}

// MARK:  -  Images
struct Images: Codable {
    let xs, sm, md, lg: String?
}
