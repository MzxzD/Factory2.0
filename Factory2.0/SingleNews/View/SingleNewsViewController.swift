//
//  ViewController.swift
//  Factoy
//
//  Created by Mateo Došlić on 06/06/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SingleNewsViewController: UIViewController  {
    var singleNewsViewModel: SingleNewsViewModel!
    
    var scrollContentView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
        
    }()
    
    var favoriteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "star_black"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "favorite"), for: .selected)
        
        return button
    }()
    
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var newsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 20)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    var newsDescription: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .justified
        text.font = UIFont(name: "AvenirNext-Italic", size: 17)
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = UIColor.white
    }
    override func viewDidDisappear(_ animated: Bool) {
        if(self.isMovingFromParentViewController){
            singleNewsViewModel.listNewsCoordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    func addSubViews() {
    
        view.addSubview(scrollContentView)
        scrollContentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollContentView.addSubview(newsImage)
        
        Alamofire.request(URL (string: singleNewsViewModel.newsData.urlToImage!)!).responseImage
            {
                response in
                if let image = response.result.value
                {
                    self.newsImage.image = image
                }
        }
        
        
        newsImage.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        newsImage.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        newsImage.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        newsImage.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        scrollContentView.addSubview(newsTitle)
        newsTitle.text = singleNewsViewModel.newsData?.title
        newsTitle.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 8).isActive = true
        newsTitle.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -8).isActive = true
        newsTitle.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 8).isActive = true
        
        scrollContentView.addSubview(newsDescription)
        newsDescription.text = singleNewsViewModel.newsData?.descriptionNews
        newsDescription.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 8).isActive = true
        newsDescription.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -8).isActive = true
        newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 8).isActive = true
        newsDescription.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor).isActive = true


        navigationItem.title = singleNewsViewModel.newsData?.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        favoriteButton.isSelected = singleNewsViewModel.newsData.isItFavourite
        
    }
    
    @objc func buttonPressed() {
        favoriteButton.isSelected =  singleNewsViewModel.addOrRemoveFromDataBase()
    }
    
    deinit {
        scrollContentView.removeFromSuperview()
    }
    
}

