//
//  ListViewController.swift
//  iOS Bootcamp Challenge
//
//  Created by Jorge Benavides on 26/09/21.
//

import UIKit
import SVProgressHUD

class ListViewController: UICollectionViewController {
    
    private var pokemons: [Pokemon] = []
    private var resultPokemons: [Pokemon] = []
    
    private var defualts = UserDefaults.standard
    private var latestSearch: String?
    private var latestSearchKey = "lastestSearch"
    
    lazy private var searchController: SearchBar = {
        let searchController = SearchBar("Search a pokemon", delegate: self)
        searchController.text = latestSearch
        searchController.showsCancelButton = !searchController.isSearchBarEmpty
        return searchController
    }()
    
    private var isFirstLauch: Bool = true
    
    // TODO: Add a loading indicator when the app first launches and has no pokemons
    private func showLoading(){
        SVProgressHUD.show()
    }
    
    private var shouldShowLoader: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    // MARK: Setup
    
    private func setup() {
        // Set up the searchController parameters.
        navigationItem.searchController = searchController
        definesPresentationContext = true
        showLoading()
        refresh()
        loadLastSearchInit()
    }
    
    // MARK: - Navigation
    private func configureNavigation(){
        configureNavigationBar(withTitle: "Pokédex", prefersLargeTitles: true, textColor: .black)
    }
    
    private func setupUI() {
        
        // Set up the collection view.
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.indicatorStyle = .white
        
        // Set up the refresh control as part of the collection view when it's pulled to refresh.
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.sendSubviewToBack(refreshControl)
    }
    
    // MARK: - UISearchViewController
    
    private func filterContentForSearchText(_ searchText: String) {
        // filter with a simple contains searched text
        resultPokemons = pokemons
            .filter {
                searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
            }
            .sorted {
                $0.id < $1.id
            }
        
        self.collectionView.reloadData()
        
        
        
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultPokemons.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCell.identifier, for: indexPath) as? PokeCell
        else { preconditionFailure("Failed to load collection view cell") }
        cell.pokemon = resultPokemons[indexPath.item]
        return cell
    }
    
    
    // TODO: Handle navigation to detail view controller
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = resultPokemons[indexPath.row]
        let controller = DetailViewController()
        controller.pokemon = pokemon
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - UI Hooks
    
    @objc func refresh() {
        shouldShowLoader = true
        
        
        // TODO: Wait for all requests to finish before updating the collection view
        PokeAPI.shared.getListPokemon { pokemons in
            self.pokemons = pokemons
            self.didRefresh()
            SVProgressHUD.dismiss()
        }
    }
    
    private func didRefresh() {
        shouldShowLoader = false
        
        guard
            let collectionView = collectionView,
            let refreshControl = collectionView.refreshControl
        else { return }
        
        refreshControl.endRefreshing()
        latestSearch = defualts.string(forKey: latestSearchKey) ?? ""
        filterContentForSearchText(latestSearch ?? "")
    }
    
    // TODO: Use UserDefaults to pre-load the latest search at start
    private func loadLastSearchInit(){
        latestSearch = defualts.string(forKey: latestSearchKey) ?? ""
        if latestSearch != "" {
            searchController.text = latestSearch
        }
        isFirstLauch = false
    }
    
    private func saveUserDefault(text: String){
        
        self.defualts.set(text, forKey: self.latestSearchKey)
        
    }
}

// TODO: Implement the SearchBar
extension ListViewController: SearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        let text = searchController.text ?? ""
        saveUserDefault(text: text)
    }
    
    func updateSearchResults(for text: String) {
        
        if !isFirstLauch {
            self.saveUserDefault(text: text)
            self.filterContentForSearchText(text)
        }
        
        
    }
    
    
}
