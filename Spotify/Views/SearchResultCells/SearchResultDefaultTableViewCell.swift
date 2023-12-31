//
//  SearchResultDefaultTableViewCell.swift
//  Spotify
//
//  Created by Begüm Tüzüner on 26.07.2023.
//

import UIKit
import SDWebImage

class SearchResultDefaultTableViewCell: UITableViewCell {
    // Identifier
    static let identifier = "SearchResultDefaultTableViewCell"
    // Label
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    // Icon
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    //Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    // Required init
    required init?(coder: NSCoder) {
        fatalError()
    }
    //Layout SubView
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        iconImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.layer.masksToBounds = true
        label.frame = CGRect(
            x: iconImageView.right+10,
            y: 0,
            width: contentView.width-iconImageView.right-15,
            height: contentView.height
        )
    }
    //PerpareforReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        iconImageView.image = nil
    }
    
    // Configure
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) {
        label.text = viewModel.title
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "person") ,completed: nil)
        
    }

}
