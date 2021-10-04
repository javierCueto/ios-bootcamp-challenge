//
//  Extensions.swift
//  iOS Bootcamp Challenge
//
//  Created by Javier Cueto on 04/10/21.
//

import UIKit

extension UIViewController {
    func configureNavigationBar(withTitle title: String, prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = .white
    }
}
