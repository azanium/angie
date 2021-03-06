//
//  GalleryPresenterTests.swift
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

class GalleryPresenterTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: GalleryPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupGalleryPresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupGalleryPresenter()
    {
        sut = GalleryPresenter()
    }
    
    // MARK: Test doubles
    
    class GalleryDisplayLogicSpy: GalleryDisplayLogic
    {
        var displayPhotosCalled = false
        
        var viewModel: Gallery.Photo.ViewModel!
        
        func displayPhotos(viewModel: Gallery.Photo.ViewModel)
        {
            displayPhotosCalled = true
            self.viewModel = viewModel
        }
    }
    
    // MARK: Tests
    
    func testDisplayFetchPhotosShouldFormatFetchedPhotosForPresentation()
    {
        // Given
        let galleryDisplayLogicSpy = GalleryDisplayLogicSpy()
        sut.viewController = galleryDisplayLogicSpy
        
        var dateComponents = DateComponents()
        dateComponents.year = 2017
        dateComponents.month = 7
        dateComponents.day = 5
        let date = Calendar.current.date(from: dateComponents)!
        
        let media = FlickrMedia(m: "m", h: "h", l: "l")
        let photos = [FlickrPhoto(title: "title", link: "link", media: media, dateTaken: date, description: "desc", published: date, author: "author", authorId: "authorId", tags: "tags")]
        let response = Gallery.Photo.Response(success: true, photos: photos)
        
        // When
        sut.presentPhotos(response: response)
        
        // Then
        let displayedPhotos = galleryDisplayLogicSpy.viewModel.photos
        for photo in displayedPhotos {
            XCTAssertEqual(photo.author, "author", "Displaying fetched photo should have correct author")
            XCTAssertEqual(photo.authorId, "authorId", "Displaying fetched photo should have correct author Id")
            XCTAssertEqual(photo.dateTaken, date, "Displaying fetched photo should have correct date")
            XCTAssertEqual(photo.description, "desc", "Displaying fetched photo should have correct description")
            XCTAssertEqual(photo.link, "link", "Displaying fetched photo should have correct link")
            XCTAssertEqual(photo.media.m, media.m, "Displaying fetched photo should have correct media")
            XCTAssertEqual(photo.published, date, "Displaying fetched photo should have correct published date")
            XCTAssertEqual(photo.tags, "tags", "Displaying fetched photo should have correct tags")
            XCTAssertEqual(photo.title, "title", "Displaying fetched photo should have correct title")
        }
    }
}
