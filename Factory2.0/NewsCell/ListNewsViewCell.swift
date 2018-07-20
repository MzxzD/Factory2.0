////
////  PreviewDataTableViewCell.swift
////  Factoy
////
////  Created by Mateo Došlić on 07/06/2018.
////  Copyright © 2018 Mateo Došlić. All rights reserved.
////

import UIKit

class ListNewsViewCell: UITableViewCell {


    // MARK: Properties

    var titleText: String?
    var newsImage: String?
    weak var cellDelegate: NewsViewCellDelegate?

    var newsTitleLabel : UILabel = {
        var titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont(name: "Verdana", size: 17)
        titleLabel.numberOfLines = 3

        return titleLabel
    }()

    var newsImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var favoriteButton : UIButton = {
        var button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "star_black"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "favorite"), for: .selected )
        button.translatesAutoresizingMaskIntoConstraints = false
       

        return button
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(newsTitleLabel)
        self.addSubview(newsImageView)
        self.addSubview(favoriteButton)

        newsImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        newsImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true


        favoriteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        favoriteButton.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor).isActive = true
        

        newsTitleLabel.leftAnchor.constraint(equalTo: newsImageView.rightAnchor, constant: 8).isActive = true
        newsTitleLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor).isActive = true
        newsTitleLabel.centerYAnchor.constraint(equalTo: newsImageView.centerYAnchor).isActive = true
        
        favoriteButton.addTarget(self, action: #selector(favTapped(sender:)) , for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
   @objc func favTapped(sender: UIButton) {
        cellDelegate?.didPressButton(self)
    }
    
}




    
    


