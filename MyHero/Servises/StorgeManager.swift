//
//  StorgeManager.swift
//  MyHero
//
//  Created by Александр Панин on 26.01.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let contactKey = "likes"
    
    private init() {}
    
    func save(hero: Heroes) {
        var heroes = fetchLikesHeroes()
        heroes.append(hero)
        heroes = heroes.sorted { $0.hero.id ?? 0 < $1.hero.id ?? 0 }
        guard let data = try? JSONEncoder().encode(heroes) else { return }
        userDefaults.set(data, forKey: contactKey)
    }
    
    func delete(index: Int) {
        var heroes = fetchLikesHeroes()
        heroes.remove(at: index)
        heroes = heroes.sorted { $0.hero.id ?? 0 < $1.hero.id ?? 0}
        guard let data = try? JSONEncoder().encode(heroes) else { return }
        userDefaults.set(data, forKey: contactKey)
    }

    func fetchLikesHeroes() -> [Heroes] {
        guard let data = userDefaults.object(forKey: contactKey) as? Data else { return [] }
        guard let heros = try? JSONDecoder().decode([Heroes].self, from: data) else { return [] }
        return heros
    }
}
