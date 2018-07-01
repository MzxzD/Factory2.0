//
//  PreviewDataTableViewCell.swift
//  Factoy
//
//  Created by Mateo Došlić on 07/06/2018.
//  Copyright © 2018 Mateo Došlić. All rights reserved.
//

import UIKit

class PreviewDataTableViewCell: UITableViewCell {

    // MARK: Properties
    var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 3
        return label
    }()

    
    
    var photoImageView: UIImageView = {
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
        self.contentView.addSubview(photoImageView)
        photoImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        photoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.contentView.addSubview(headlineLabel)
        headlineLabel.leftAnchor.constraint(equalTo: photoImageView.rightAnchor, constant: 8).isActive = true
        headlineLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 8).isActive = true
        headlineLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor, constant: -8).isActive = true
        

        
        
    }
    

}
