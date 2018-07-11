//
//  PreviewDataTableViewCell.swift
//  Factoy
//
//  Created by Mateo Došlić on 07/06/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit

class ListNewsViewCell: UITableViewCell {

    // MARK: Properties
    var newsTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Verdana", size: 17)
        label.numberOfLines = 3
        return label
    }()

    
    
    var newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        self.contentView.addSubview(newsImage)
        newsImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        newsImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
        newsImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.contentView.addSubview(newsTitle)
        newsTitle.leftAnchor.constraint(equalTo: newsImage.rightAnchor, constant: 8).isActive = true
        newsTitle.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 8).isActive = true
        newsTitle.centerYAnchor.constraint(equalTo: newsImage.centerYAnchor, constant: -8).isActive = true
        

        
        
    }
    

}
