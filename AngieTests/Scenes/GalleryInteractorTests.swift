//
//  GalleryInteractorTests.swift
//  Angie
//
//  Created by Suhendra Ahmad on 7/5/17.
//  Copyright (c) 2017 Suhendra Ahmad. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import Angie
import XCTest

class GalleryInteractorTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: GalleryInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupGalleryInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupGalleryInteractor()
    {
        sut = GalleryInteractor()
    }
    
    
    // MARK: Test doubles
    
    class GalleryPresentationLogicSpy: GalleryPresentationLogic {
        var presentPhotosCalled = false
        
        func presentPhotos(response: Gallery.Photo.Response) {
            presentPhotosCalled = true
        }
    }
    
    class GalleryWorkerSpy: GalleryWorker {
        var fetchPhotosCalled = false
        
        typealias GalleryFetchPhotosHandler = (Bool, [FlickrPhoto])->Void
        
        override func fetchPhotos(completionHandler: GalleryFetchPhotosHandler?){
            fetchPhotosCalled = true
            completionHandler?(true, [])
        }
    }

    // MARK: Tests

    func testFetchPhotosShouldAskGalleryWorkerToFetchPhotosAndPresenterToFormatResult()
    {
        // Given
        let galleryPresentationLogicSpy = GalleryPresentationLogicSpy()
        sut.presenter = galleryPresentationLogicSpy
        let galleryWorkerSpy = GalleryWorkerSpy()
        sut.worker = galleryWorkerSpy
        
        // When
        let request = Gallery.Photo.Request()
        sut.fetchPhotos(request: request)
        
        // Then
        XCTAssert(galleryWorkerSpy.fetchPhotosCalled, "fetchPhotos() should ask GalleryWorker to fetch photos")
        XCTAssert(galleryPresentationLogicSpy.presentPhotosCalled, "fetchPhotos() should ask Gallery Presenter to format photos")
    }
}
