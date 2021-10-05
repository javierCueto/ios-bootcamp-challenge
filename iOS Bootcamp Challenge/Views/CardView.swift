//
//  CardView.swift
//  iOS Bootcamp Challenge
//
//  Created by Marlon David Ruiz Arroyave on 28/09/21.
//

import UIKit

class CardView: UIView {
    private let margin: CGFloat = 20
    
    var card: Card?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var aboutStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = margin/2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    required init(card: Card) {
        self.card = card
        super.init(frame: .zero)
        setup()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupUI()
    }
    
    private func setup() {
        guard let card = card else { return }
        let color = PokemonColor.getTypeColor(name: card.pokemonType)
        card.items.forEach { item in
            let label = UILabel()
            label.textAlignment = .center
            let attributedString = NSMutableAttributedString(string: "\(item.title) : ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            attributedString.append(NSMutableAttributedString(string: item.description, attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            label.textColor = .white
            label.attributedText = attributedString
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 40).isActive = true
            label.layer.cornerRadius = 7.0
            label.layer.masksToBounds = true
            label.backgroundColor = color
            aboutStackView.addArrangedSubview(label)
        }
        
        titleLabel.text = card.title
        backgroundColor = .white
        layer.cornerRadius = 20
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin * 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.70).isActive = true
        
        // TODO: Display pokemon info (eg. types, abilities)
        
        addSubview(aboutStackView)
        aboutStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: margin).isActive = true
        aboutStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).isActive = true
        aboutStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin).isActive = true
    }
    
}
