//
//  SuperHeros.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import Foundation

struct Heroes: Codable {
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
        
        Experience:
        
        Intelligence  \(powerstats.intelligence ?? 0)
        Strength     \(powerstats.strength ?? 0)
        Speed         \(powerstats.speed ?? 0)
        Durability    \(powerstats.durability ?? 0)
        Power         \(powerstats.power ?? 0)
        Combat       \(powerstats.combat ?? 0)
        """
    }
    var appearanceLabel: String { """
        
        Appearance:
        
        Race         \(appearance.race ?? "")
        Gender      \(appearance.gender ?? "")
        Eye Color   \(appearance.eyeColor ?? "")
        Hair Color   \(appearance.hairColor ?? "")
        Height       \(appearance.height?[1] ?? "")
        Weight       \(appearance.weight?[1] ?? "")
        """
    }
    
    var biographyLabel: String { """
        
        Biography:
         
        Full Name              \(biography.fullName ?? "")
        Alter Egos             \(biography.alterEgos ?? "")
        Place Of Birth        \(biography.placeOfBirth ?? "")
        First Appearance   \(biography.firstAppearance ?? "")
        Publisher               \(biography.publisher ?? "")
        Alignment             \(biography.alignment ?? "")
        """
    }
    
    var workLabel: String { """
        
        Work and Connections:
         
        Occupation           \(work.occupation ?? "")
        Base                     \(work.base ?? "")
        Group Affiliation    \(connections.groupAffiliation ?? "")
        Relative                \(connections.relative ?? "")
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
