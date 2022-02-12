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
    
 
    private var heroes: [Heroes] = []
    private var likeHeroes: [Heroes] = []
    private var filteredHeroes: [Heroes] = []
    private var checkHeroes: [Heroes] = []
    private let navBarAppearence = UINavigationBarAppearance()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let aspectRatioPerItem: CGFloat = 4 / 3
    private let itemsPerRows: CGFloat = 2
    private let sectionInsert = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var isLiked: Bool = false
    
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
    
    private func checkLiked() {
        checkHeroes = isLiked ? likeHeroes : heroes
    }
        
    private func setupUI() {
        navBarAppearence.titleTextAttributes = [.font: UIFont(name: "Thonburi", size: 20) ?? ""]
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        
        let filterButton: UIBarButtonItem = {
            let button = UIBarButtonItem(
                image: UIImage(systemName: "heart"),
                style: .plain,
                target: self,
                action: #selector(filterButtonPress)
            )
            button.tintColor = .black
            return button
        }()
        navigationItem.leftBarButtonItem = filterButton // добавил кнопку "любимых"
        collectionView.showsVerticalScrollIndicator = false  // скрыть вертикальную полоску прокрутки
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 15)
            textField.textColor = .black
        }
    }
}
// MARK: - функция получения и формирования массива информации Fetch Data
extension HeroesCollectionViewController {
    
    func fetchData(_ url: String) {
        
        NetworkingManager.shared.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                // формируем новый массив с элементом "любимы"
                for hero in data {
                    // проверка ели герой присутствует в массиве "любимых", то признак true
                    if self.likeHeroes.contains(where: { heros in heros.hero.id == hero.id }) {
                        self.heroes.append(Heroes(like: true, hero: hero))
                    } else {
                        self.heroes.append(Heroes(like: false, hero: hero))
                    }
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HeroesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - установка явного размеров ячеек в секции
    // ЛУЧШЕ использовать размеры привязанные к ширине экрана
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidth = sectionInsert.left * (itemsPerRows + 1)
        let avalibalWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = avalibalWidth / itemsPerRows
        let heigthPerItem = aspectRatioPerItem * widthPerItem
        
        return CGSize(width: widthPerItem, height: heigthPerItem)
    }
    
    // MARK: -  установка отступов ячеек от границ секций
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsert
    }
    
    // MARK: -  установка расстояния между рядами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsert.left
    }
    // MARK: -  установка расстояния между столбцами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsert.left
    }
}

// MARK: - функция делегата для отработки нажатия кнопки "понравилась"
extension HeroesCollectionViewController: HeroesCollectionViewCellDelegate {
    
    func button(for cell: HeroesCollectionViewCell) {
        // забираем из ячейки данные персонажа
        guard let hero = cell.heroes else { return }
        // -  сохраняем или удаляем из UserDefalts "любимых"
        if let index = likeHeroes.firstIndex(where: { likeHehos in likeHehos.hero.id == cell.id}) {
            StorageManager.shared.delete(index: index)
        } else {
            StorageManager.shared.save(hero: hero)
        }
        // - перезагружаем массив "любимых"
        likeHeroes = StorageManager.shared.fetchLikesHeroes()
        // - определяем индекс основного массива и меняем значение "любимый" на противоположное
        if let index = heroes.firstIndex(where: { heros in heros.hero.id == cell.id }) {
            heroes[index].like.toggle()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension HeroesCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        checkLiked()
        filteredHeroes = checkHeroes.filter { heroes in
            let race = heroes.hero.appearance.race?.lowercased() ?? ""
            let  gender = heroes.hero.appearance.gender?.lowercased() ?? ""
            let name = heroes.hero.name.lowercased()
            let biography = heroes.hero.biographyLabel.lowercased()
            let work = heroes.hero.workLabel.lowercased()
            let text = searchText.lowercased()
            return name.contains(text) || biography.contains(text) || work.contains(text) || race.contains(text) || gender.contains(text)
        }
        collectionView.reloadData()
    }
}

