//
//  ViewController.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 13.02.22.
//

import UIKit

class SearchViewController: UIViewController, SearchViewModelDelegate {
    private var viewModel: SearchViewModel?
    private var viewBinder: SearchViewBinder?

    private let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Meister-Search"
        navigationItem.searchController = searchController

        let viewModel = SearchViewModel(delegate: self)
        self.viewModel = viewModel

        let searchView = SearchView(frame: view.frame)

        let viewBinder = SearchViewBinder(model: viewModel)
        viewBinder.bind(to: searchView)
        self.viewBinder = viewBinder

        searchController.searchResultsUpdater = viewBinder

        self.view = searchView
    }

    // MARK: SearchViewModelDelegate
    func presentTaskSelectedAlert(name: String) {
        let alertController = UIAlertController(title: "Task selected", message: name, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)

        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}
