//
//  SuperHerosCollectionViewController.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import UIKit

protocol SuperHerosCollectionViewCellDelegate {
    func button (for cell: SuperHerosCollectionViewCell)
}

class SuperHerosCollectionViewController: UICollectionViewController {
    
    var heros: [Heros] = []
    var likeHeros: [Heros] = []
    let navBarAppearence = UINavigationBarAppearance()
    
    
    
    private let aspectRatioPerItem: CGFloat = 4 / 3
    private let itemsPerRows: CGFloat = 2
    private let sectionInsert = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private var likeBool: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        likeHeros = StorageManager.shared.fetchHeros()
        fetchData(Links.superHerosApi.rawValue)
    }
    
    // Вызывается при изменении размеров вью
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        collectionView.reloadData()
//    }
    
    
    // MARK: - Navigation
    
    override func collectionView(_ colletionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImage", sender: indexPath.item )
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let index = sender as? Int else { return }
        let showVC = segue.destination as! ImageHeroViewController
        showVC.hero = likeBool ? likeHeros[index] : heros[index]
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeBool ? likeHeros.count : heros.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "herosCell", for: indexPath) as!  SuperHerosCollectionViewCell
        let hero = likeBool ? likeHeros[indexPath.item] : heros[indexPath.item]
        cell.configure(hero)
        cell.delegate = self
        return cell
    }
    
    // MARK: - функция отработки фильтра "любимых" картинок
    @objc func filterButtonPress() {
        guard let button = navigationItem.leftBarButtonItem else { return }
        likeBool.toggle()
        button.image = likeBool ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeHeros = StorageManager.shared.fetchHeros()
        collectionView.reloadData()
    }
    
    private func setupUI() {
        navBarAppearence.titleTextAttributes = [.font: UIFont(name: "Marker Felt Thin", size: 20) ?? ""]
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
}
// MARK: - функция получения и формирования массива информации Fetch Data
extension SuperHerosCollectionViewController {
    
    func fetchData(_ url: String) {
        
        NetworkingManager.shared.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                // формируем новый массив с элементом "любимы"
                for hero in data {
                    // проверка ели герой присутствует в массиве "любимых", то признак true
                    if self.likeHeros.contains(where: { heros in heros.hero.id == hero.id }) {
                        self.heros.append(Heros(like: true, hero: hero))
                    } else {
                        self.heros.append(Heros(like: false, hero: hero))
                    }
                }
                self.collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SuperHerosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
extension SuperHerosCollectionViewController: SuperHerosCollectionViewCellDelegate {
    
    func button(for cell: SuperHerosCollectionViewCell) {
        // забираем из ячейки данные персонажа
        guard let hero = cell.heros else { return }
        // -  сохраняем или удаляем из UserDefalts "любимых"
        if let index = likeHeros.firstIndex(where: { likeHehos in likeHehos.hero.id == cell.id}) {
            StorageManager.shared.delete(index: index)
        } else {
            StorageManager.shared.save(hero: hero)
        }
        // - перезагружаем массив "любимых"
        likeHeros = StorageManager.shared.fetchHeros()
        // - определяем индекс основного массива и меняем значение "любимый" на противоположное
        if let index = heros.firstIndex(where: { heros in heros.hero.id == cell.id }) {
            heros[index].like.toggle()
        }
    }
}
    

