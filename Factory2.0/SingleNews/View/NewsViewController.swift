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

class NewsViewController: UIViewController  {
    
    // MARK: variables
    var modelView: NewsViewModel!
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "AvenirNext-Bold", size: 23)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()
    
    var storyText: UITextView = {
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
        if(isMovingFromParentViewController){
           // modelView.delegate?.
        }
    }
    
    func addSubViews() {
        
        view.addSubview(photoImageView)
        Alamofire.request(URL (string: modelView.newsData.urlToImage)!).responseImage
            {
                response in
                if let image = response.result.value
                {
                    self.photoImageView.image = image
                }
        }
        
        
        photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        view.addSubview(headlineLabel)
        headlineLabel.text = nil
        headlineLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8).isActive = true
        headlineLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 305) .isActive = true
        
        
        view.addSubview(storyText)
        storyText.text = nil
        storyText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        storyText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        storyText.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 8).isActive = true
        storyText.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = modelView.newsData?.title
        headlineLabel.text = modelView.newsData?.title
        storyText.text = modelView.newsData?.description
        
        
        
    }
    // Deinitialization of the ViewContoller
    deinit {
        modelView = nil
        photoImageView.image = nil
        navigationItem.title = nil
        headlineLabel.text = nil
        storyText.text = nil
        print("View has been deinnitialized...")
    }
    
}

