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

class DataViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var storyText: UITextView = {
        let tekst = UITextView()
        tekst.translatesAutoresizingMaskIntoConstraints = false
        tekst.isEditable = false
        tekst.isScrollEnabled = true
        return tekst
    }()
    
    
    var newsToDisplay: NewsViewData!
    // Prikazati sa preznetera

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.backgroundColor = UIColor.white

    }
            
    func addSubViews() {
        
        view.addSubview(photoImageView)
        Alamofire.request(URL (string: newsToDisplay!.imageUrl)!).responseImage
            {
                response in
                if let image = response.result.value
                {
                    self.photoImageView.image = image
                }
        }
       

        photoImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        photoImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        view.addSubview(headlineLabel)
        headlineLabel.text = nil
        headlineLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        headlineLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 308).isActive = true
        headlineLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 360) .isActive = true
        
        
        view.addSubview(storyText)
        storyText.text = nil
        storyText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        storyText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        storyText.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 8).isActive = true
        storyText.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        navigationItem.title = newsToDisplay?.headline
        headlineLabel.text = newsToDisplay?.headline
        storyText.text = newsToDisplay?.story
        
        
        
    }
    
    
}

