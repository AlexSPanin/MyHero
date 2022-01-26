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
