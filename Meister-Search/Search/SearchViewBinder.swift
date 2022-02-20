//
//  SearchViewBinder.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 14.02.22.
//

import Foundation
import UIKit

final class SearchViewBinder: NSObject, SearchViewModelView, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    private let model: SearchViewModel
    private weak var view: SearchView?

    private var tasks = [Task]()
    private var sections = [Section]()
    private var projects = [Project]()

    init(model: SearchViewModel) {
        self.model = model
    }

    func bind(to view: SearchView) {
        self.view = view

        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.sectionHeaderHeight = 0

        view.segmentedControl.addTarget(self, action: #selector(segmentChanged(_ :)), for: .valueChanged)
        
        model.view = self
    }

    @objc
    func segmentChanged(_ segmentControl: UISegmentedControl) {
        model.segmentChanged(index: segmentControl.selectedSegmentIndex, tasks: tasks)
    }

    private func getProjectName(index: Int) -> String {
        let section = sections.first {
            $0.id == tasks[index].sectionID
        }

        return projects.first {
            $0.id == section?.projectID
        }?.name ?? ""
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if tasks.isEmpty {
            view?.emptyTableImageView.isHidden = false

            return 0
        } else {
            view?.emptyTableImageView.isHidden = true
        }

        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchView.TaskCell.reuseIdentifier, for: indexPath) as? SearchView.TaskCell else {
            fatalError("Error trying to dequeue cell")
        }

        cell.taskName = tasks[indexPath.section].name
        cell.taskProject = getProjectName(index: indexPath.section)

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let name = tasks[indexPath.section].name {
            model.taskSelected(name: name)
        }
    }

    // MARK: - SearchViewModelView
    func setData(results: Results) {
        if let tasks = results.tasks, let sections = results.sections, let projects = results.projects {
            self.tasks = tasks
            self.sections = sections
            self.projects = projects

            view?.tableView.reloadData()
        }
    }

    func removeData() {
        tasks = []
        sections = []
        projects = []

        view?.tableView.reloadData()
    }

    func setTasks(tasks: [Task]) {
        self.tasks = tasks

        view?.tableView.reloadData()
    }

    func showSpinner() {
        view?.loadingIndicator.startAnimating()
    }

    func hideSpinner() {
        view?.loadingIndicator.stopAnimating()
    }


    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        model.updateSearchResults(text: text)
    }
}
