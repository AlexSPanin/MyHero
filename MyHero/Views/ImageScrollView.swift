//
//  ImageScrollView.swift
//  MyHero
//
//  Created by Александр Панин on 09.02.2022.
//

import UIKit

class ImageScrollView: UIScrollView {
    
    var imageZoomView: UIImageView?
    
    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()
    
    // MARK: - передаем что наш класс должен использовать своства делегата
    override init(frame: CGRect) {
        super.init(frame: frame)
        // сообщаем кто будет выполнять функции делегата
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - обновление интерфейса
    override func layoutSubviews() {
        super.layoutSubviews()
        positionImage()
    }
    
    // функция отрпбатывающая нажание на экран см в переменной
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        // передаем где нажатие
        let location = sender.location(in: sender.view)
        zoomToTap(point: location, animated: true)
    }
    // MARK: - загрузка изображения в ScrollView
    func setImage(hero: Hero) {
        
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        
        guard let url = URL(string: hero.images.lg ?? "") else { return }
        
        getImage(from: url) { result in
            switch result {
            case .success(let image):
                self.imageZoomView = UIImageView(image: image)
                guard let imageZoomView = self.imageZoomView else { return }
                self.addSubview(imageZoomView)
                self.configurate(imageSize: image.size)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // прописываем логику при первом нажатии 2 раза - увеличивается, а при повторном уменьшается
    func zoomToTap(point: CGPoint, animated: Bool) {
        let currectScale = zoomScale
        let minScale = minimumZoomScale
        let maxScale = maximumZoomScale
        
        if (minScale == maxScale && minScale > 1) {
            return
        }
        let toScale = maxScale
        let finalScale = (currectScale == minScale ) ? toScale : minScale
        
        let zoomRect = zoomRect(scale: finalScale, center: point)
        // встроенная функция
        zoom(to: zoomRect, animated: animated)
    }
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds
        
        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        
        return zoomRect
    }
    
    // MARK: - загрузка размеров изображения
    private func configurate(imageSize: CGSize) {
        
        // передаем размеры картинки
        contentSize = imageSize
        // задаем параметры зуминга
        setZoomScale()
        
        // свойству zoomScale у UIScrollView присваиваем минимальный зум
        zoomScale = minimumZoomScale
        
        imageZoomView?.addGestureRecognizer(zoomingTap)
        imageZoomView?.isUserInteractionEnabled = true
        
        decelerationRate = UIScrollView.DecelerationRate.normal
    }
    // MARK: - установка параметров изображения после зуминга
    private func setZoomScale() {
        //  извлечение опционала
        guard let imageZoomView = imageZoomView else { return }
        // фиксируем размеры рамки и изображения
        let boundsSize = self.bounds.size
        let imageSize = imageZoomView.bounds.size
        // вычисляем соотношения экранов по x и y
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        // определяем минимальный и максимальный зум
        let minScale = min(xScale, yScale)
        let maxScale: CGFloat = max(1, minScale)
        // задаем параметры минимального и максимального зума
        minimumZoomScale = minScale
        maximumZoomScale = maxScale
    }
    
    // MARK: - задаем место расположения картинки после зума
    private func positionImage() {
        //  извлечение опционала
        guard let imageZoomView = imageZoomView else { return }
        // фиксируем размеры рамки и изображения
        let boundsSize = self.bounds.size
        
        var frameToCenter = imageZoomView.frame
        // если размеры высоты view при зум меньше ширины экрана то view вписывается в ширику экрана
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        // если размеры ширины view при зум меньше ширины экрана то view вписывается в ширику экрана
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        // присваиваем новый frame
        imageZoomView.frame = frameToCenter
    }
    
    // MARK: - получение картинки из кэша
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        if let cacheImage = ImageCache.shared.object(forKey: ("lg" + url.lastPathComponent) as NSString) {
            completion(.success(cacheImage))
            return
        }
        NetworkingManager.shared.fetchImage(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                ImageCache.shared.setObject(image, forKey: ("lg" + url.lastPathComponent) as NSString)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    
    // MARK: - задаем методы делегата UIScrollViewDelegate
    // Запрашивает делегата о масштабировании вида при приближении масштабирования на виде прокрутки.
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView
    }
    // Сообщает делегату, что коэффициент масштабирования вида прокрутки изменился.
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        positionImage()
    }
}
