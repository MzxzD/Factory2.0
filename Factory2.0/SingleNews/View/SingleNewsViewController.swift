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
    // MARK: variables
    var singleNewsViewModel: SingleNewsViewModel!
    
    var favoriteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "star_black"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "favorite"), for: .selected)
        
        return button
    }()
    
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        text.isScrollEnabled = true
        return text
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = UIColor.white
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("View Dissapeared")
        if(self.isMovingFromParentViewController){
            print("IT is moving to parent coordinator")
            singleNewsViewModel.listNewsCoordinatorDelegate?.viewControllerHasFinished()
        }
    }
    
    
    
    func addSubViews() {
        view.addSubview(newsImage)
        Alamofire.request(URL (string: singleNewsViewModel.newsData.urlToImage!)!).responseImage
            {
                response in
                if let image = response.result.value
                {
                    self.newsImage.image = image
                }
        }
        
        newsImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        newsImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        newsImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 55).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(newsTitle)
        newsTitle.text = nil
        newsTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        newsTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        newsTitle.topAnchor.constraint(equalTo: newsImage.bottomAnchor, constant: 8).isActive = true
        newsTitle.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(newsDescription)
        newsDescription.text = nil
        newsDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        newsDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 8).isActive = true
        newsDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = singleNewsViewModel.newsData?.title
        newsTitle.text = singleNewsViewModel.newsData?.title
        newsDescription.text = singleNewsViewModel.newsData?.descriptionNews
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        favoriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        favoriteButton.isSelected = singleNewsViewModel.newsData.isItFavourite
        
        
    }
    
    
    @objc func buttonPressed() {
        favoriteButton.isSelected =  singleNewsViewModel.addOrRemoveFromDataBase()
        
    }
    

    // Deinitialization of the ViewContoller
    deinit {
        
        print("View has been deinnitialized...")
    }
    
}

