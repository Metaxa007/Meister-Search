//
//  SearchViewModel.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 14.02.22.
//

import Foundation
import CoreData
import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func presentTaskSelectedAlert(name: String)
}

protocol SearchViewModelView: AnyObject {
    func setData(results: Results)
    func setTasks(tasks: [Task])
    func showSpinner()
    func hideSpinner()
    func removeData()
}

final class SearchViewModel {
    private unowned let delegate:SearchViewModelDelegate

    private var activeSegment = Segment.all
    private var currentSearchInput = ""
    private var workItem: DispatchWorkItem?

    init(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    weak var view: SearchViewModelView?

    private func fetchTasks(endpoint: URL) {
        view?.showSpinner()
        
        let request = Endpoint.makeRequest(endpoint: endpoint)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil, let data = data else {
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return
            }

            let jsonDecoder = JSONDecoder()

            if let data = try? jsonDecoder.decode(Data.self, from: data) {
                guard let results = data.results else { return }

                DispatchQueue.main.async {
                    guard let self = self else { return }

                    self.view?.setData(results: results)
                    self.view?.hideSpinner()

                    if let tasks = results.tasks, !tasks.isEmpty {
                        CoreDataManager.shared.storeTasks(tasks: tasks)
                    }
                }
            }
        }.resume()
    }

    func segmentChanged(index: Int, tasks: [Task]) {
        switch index {
        case 0:
            activeSegment = Segment.all
        case 1:
            activeSegment = Segment.active
        case 2:
            activeSegment = Segment.archived
        default:
            break
        }

        if !currentSearchInput.isEmpty {
            performSearch(name: currentSearchInput)
        }
    }

    func updateSearchResults(text: String) {
        currentSearchInput = text

        if text.isEmpty {
            view?.removeData()
            return
        }

        performSearch(name: text)
    }

    func taskSelected(name: String) {
        delegate.presentTaskSelectedAlert(name: name)
    }

    private func performSearch(name: String) {
        isOnline() ? dispatchSearchTask(name: name) : getTasksFromCoreData(name: name)
    }

    private func isOnline() -> Bool {
        return NetworkMonitor.shared.isConnected
    }

    private func getEndpoint(task: String) -> URL {
        return Endpoint.filter(status: activeSegment, task: task).url
    }

    private func dispatchSearchTask(name: String) {
        workItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            self.fetchTasks(endpoint: self.getEndpoint(task: name))
        }
        self.workItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: workItem)
    }

    private func getTasksFromCoreData(name: String) {
        if !name.isEmpty {
            let tasks = CoreDataManager.shared.getTasks(name: name, status: activeSegment)

            view?.setTasks(tasks: tasks)
        } else {
            view?.removeData()
        }
    }

    private struct Segment {
        static let all = [18,1]
        static let active = [1]
        static let archived = [18]
    }
}
