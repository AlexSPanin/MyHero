//
//  NetworkManager.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import Foundation

enum Links: String, CaseIterable {
    case kitsuApi = "https://kitsu.io/api/edge/anime?filter[text]="
    case rickAndMortyApi = "https://rickandmortyapi.com/api/character"
    case superHerosApi = "https://cdn.rawgit.com/akabab/superhero-api/0.2.0/api/all.json"
}
