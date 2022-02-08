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
    
    func save(hero: Heros) {
        var heros = fetchHeros()
        heros.append(hero)
        
        guard let data = try? JSONEncoder().encode(heros) else { return }
        userDefaults.set(data, forKey: contactKey)
    }
    
    func delete(index: Int) {
        var heros = fetchHeros()
        heros.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(heros) else { return }
        userDefaults.set(data, forKey: contactKey)
    }

    func fetchHeros() -> [Heros] {
        guard let data = userDefaults.object(forKey: contactKey) as? Data else { return [] }
        guard let heros = try? JSONDecoder().decode([Heros].self, from: data) else { return [] }
        return heros
    }
}
