//
//  Extensions.swift
//  iOS Bootcamp Challenge
//
//  Created by Javier Cueto on 04/10/21.
//

import UIKit

extension UIViewController {
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool, textColor: UIColor = UIColor.white) {
        guard let navbar = self.navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        navbar.standardAppearance = appearance
        navbar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navbar.tintColor = textColor
    }
}
