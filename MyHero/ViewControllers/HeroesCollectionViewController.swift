//
//  SuperHerosCollectionViewController.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import UIKit

protocol HeroesCollectionViewCellDelegate {
    func button (for cell: HeroesCollectionViewCell)
}

class HeroesCollectionViewController: UICollectionViewController {
    
    let navBarAppearence = UINavigationBarAppearance()
    let searchController = UISearchController(searchResultsController: nil)
    var heroes: [Heroes] = []
    var likeHeroes: [Heroes] = []
    var filteredHeroes: [Heroes] = []
    var checkHeroes: [Heroes] = []
    var isLiked: Bool = false
    
    let aspectRatioPerItem: CGFloat = 4 / 3
    let itemsPerRows: CGFloat = 2
    let sectionInsert = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSearchController()
        likeHeroes = StorageManager.shared.fetchLikesHeroes()
        likeHeroes = likeHeroes.sorted { $0.hero.id ?? 0 < $1.hero.id ?? 0 }
        fetchData(Links.superHerosApi.rawValue)
    }
    
    // MARK: - Navigation
    
    override func collectionView(_ colletionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImage", sender: indexPath.item )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        checkLiked()
        guard let index = sender as? Int else { return }
        let showVC = segue.destination as! DetailedViewController
        showVC.hero = isFiltering ? filteredHeroes[index].hero : checkHeroes[index].hero
        
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        checkLiked()
        return isFiltering ? filteredHeroes.count : checkHeroes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "heroesCell", for: indexPath) as!  HeroesCollectionViewCell
        checkLiked()
        let hero = isFiltering ? filteredHeroes[indexPath.item] : checkHeroes[indexPath.item]
        cell.configure(hero)
        cell.delegate = self
        return cell
    }
    
    // MARK: - функция отработки фильтра "любимых" картинок
    @objc func filterButtonPress() {
        guard let button = navigationItem.leftBarButtonItem else { return }
        isLiked.toggle()
        button.image = isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeHeroes = StorageManager.shared.fetchLikesHeroes()
        collectionView.reloadData()
    }
}



