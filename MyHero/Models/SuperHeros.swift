//
//  SuperHeros.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import Foundation

// MARK - Hero
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
}

// MARK: - Powerstats
struct Powerstats: Codable {
    let intelligence: Int?
    let strength: Int?
    let speed: Int?
    let durability: Int?
    let power: Int?
    let combat: Int?
}

// MARK: - Appearance
struct Appearance: Codable {
    let gender: String?
    let race: String?
    let height: [String]?
    let weight: [String]?
    let eyeColor: String?
    let hairColor: String?
}

// MARK: - Biography
struct Biography: Codable {
    let fullName: String?
    let alterEgos: String?
    let aliases: [String]?
    let placeOfBirth: String?
    let firstAppearance: String?
    let publisher: String?
    let alignment: String?
}

// MARK: - Work
struct Work: Codable {
    let occupation: String?
    let base: String?
}

//MARK: - Connections
struct Connections: Codable {
    let groupAffiliation: String?
    let relatives: String?
}

// MARK:  -  Images
struct Images: Codable {
    let xs: String?
    let sm: String?
    let md: String?
    let lg: String?
}
