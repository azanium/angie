//
//  GalleryViewController.swift
//  Angie
//
//  Created by Suhendra Ahmad on 7/4/17.
//  Copyright (c) 2017 Suhendra Ahmad. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import ALThreeCircleSpinner
import SnapKit
import Kingfisher

protocol GalleryDisplayLogic: class
{
    func presentPhotos(viewModel: Gallery.Photo.ViewModel)
}

class GalleryViewController: UICollectionViewController, GalleryDisplayLogic
{
    var interactor: GalleryBusinessLogic?
    var router: (NSObjectProtocol & GalleryRoutingLogic & GalleryDataPassing)?
    
    // MARK: MemVars & Properties
    
    private let cellIdentifier = "Cell"
    
    // Photos and Gallery margins
    fileprivate let photosPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private let spinner = ALThreeCircleSpinner(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    var presentedPhotos = [FlickrPhoto]()
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = GalleryInteractor()
        let presenter = GalleryPresenter()
        let router = GalleryRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // Setup the spinner for loading indicator here
    private func setupSpinner() {
        collectionView?.addSubview(spinner)
        spinner.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupSpinner()
        
        loadPhotos()
    }
    
    // MARK: - UICollectionView Data Source and Delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presentedPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UICollectionViewCell
        
        let photo = self.presentedPhotos[indexPath.row]
        
        let url = URL(string: photo.media.m)!
        
        let resource = ImageResource(downloadURL: url, cacheKey: photo.media.m)
        //cell.photoView.kf.indicatorType = .activity
        //cell.photoView.kf.setImage(with: resource)
        
        // Configure the cell
        return cell
    }
    
    // MARK: Gallery Events
    
    func loadPhotos()
    {
        spinner.startAnimating()
        
        let request = Gallery.Photo.Request()
        interactor?.fetchPhotos(request: request)
    }
    
    
    // Present the photos sent from the presenter
    func presentPhotos(viewModel: Gallery.Photo.ViewModel)
    {
        spinner.stopAnimating()
        
        self.presentedPhotos = viewModel.photos
        
        self.collectionView?.reloadData()
    }
}

// Adjust the insets and item size for the gallery with flow layout delegate

extension GalleryViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (photosPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / photosPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
