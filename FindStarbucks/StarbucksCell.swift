//
//  StarbucksCell.swift
//  FindStarbucks
//
//  Created by Alessandro Musto on 3/31/17.
//  Copyright © 2017 Lmusto. All rights reserved.
//

import UIKit

class StarbucksCell: UICollectionViewCell {

    var starbucks: Starbucks? {
        didSet {
            if let distance = starbucks?.distance {
                distanceLabel.text = "about \(Float(distance)) miles away"
            } else {
                distanceLabel.text = "unknown distance"
            }
            if let string = starbucks?.address {
                if let firstComma = string.characters.index(of: ",") {
                    streetLabel.text = String(string.characters.prefix(upTo: firstComma))
                } else {
                    streetLabel.text = string
                }
            }
        }
    }

    fileprivate var distanceLabel: UILabel!
    fileprivate var streetLabel: UILabel!
    fileprivate var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setConstraints()
    }

    func commonInit() {

        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 10.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        contentView.layer.masksToBounds = true

        //set shadowing
        layer.cornerRadius = 10.0
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0

        distanceLabel = UILabel()
        distanceLabel.font = UIFont(name: "Avenir", size: 12)
        distanceLabel.tintColor = UIColor.black
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(distanceLabel)

        streetLabel = UILabel()
        streetLabel.font = UIFont(name: "Avenir", size: 14)
        streetLabel.tintColor = UIColor.black
        streetLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(streetLabel)

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        contentView.addSubview(imageView)

    }

    func setConstraints() {
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        streetLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        streetLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 50).isActive = true
        streetLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        streetLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10).isActive = true

        distanceLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 50).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: streetLabel.bottomAnchor, constant: 0).isActive = true
    }

}
