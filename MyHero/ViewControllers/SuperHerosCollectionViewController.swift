//
//  SuperHerosCollectionViewController.swift
//  MyHero
//
//  Created by Александр Панин on 24.01.2022.
//

import UIKit

class SuperHerosCollectionViewController: UICollectionViewController {
    
var heros: [Hero] = []

    private let aspectRatioPerItem: CGFloat = 4 / 3
    private let itemsPerRows: CGFloat = 3
    private let sectionInsert = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // MARK: - второй способ задания установок ячеек через as!
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 128, height: 256)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        */
        
        collectionView.showsVerticalScrollIndicator = false  // скрыть вертикальную полоску прокрутки
        fetchHeros(Links.superHerosApi.rawValue)

    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heros.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "herosCell", for: indexPath) as!  SuperHerosCollectionViewCell
    
        let hero = heros[indexPath.row]
        cell.configure(hero)
    
        return cell
    }
}
// MARK: - Fetch Data

extension SuperHerosCollectionViewController {
    func fetchHeros(_ url: String) {
        NetworkingManager.shared.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                self.heros = data
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
