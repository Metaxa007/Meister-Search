//
//  SearchView.swift
//  Meister-Search
//
//  Created by Artsem Lemiasheuski on 14.02.22.
//

import Foundation
import UIKit

final class SearchView: UIView {
    let segmentedControl = UISegmentedControl (items: ["All","Active","Archived"])
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let descriptionLabel = UILabel()
    let emptyTableImageView = UIImageView()
    let loadingIndicator = UIActivityIndicatorView(style: .large)

    private struct Layout {
        static let cellHeight: CGFloat = 100
        static let stackViewSpacing: CGFloat = 10
    }

    class TaskCell: UITableViewCell {
        static let reuseIdentifier = "TaskCell"

        private let taskProjectLabel = UILabel()
        private let taskNameLabel = UILabel()
        private let stackView = UIStackView()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

            setupViews()
            setupConstraints()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        var taskProject: String? {
            set { taskProjectLabel.text = newValue }
            get { taskProjectLabel.text }
        }

        var taskName: String? {
            set { taskNameLabel.text = newValue }
            get { taskNameLabel.text }
        }

        private func setupViews() {
            taskProjectLabel.textColor = .systemGray
            taskProjectLabel.font = UIFont.boldSystemFont(ofSize: 16)

            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .leading
            stackView.spacing = Layout.stackViewSpacing
        }

        private func setupConstraints() {
            [taskProjectLabel, taskNameLabel].forEach { subview in
                subview.translatesAutoresizingMaskIntoConstraints = false
                stackView.addArrangedSubview(subview)
            }

            [stackView].forEach { subview in
                subview.translatesAutoresizingMaskIntoConstraints = false
                addSubview(subview)
            }

            NSLayoutConstraint.activate([
                stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
                stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemGray6

        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        emptyTableImageView.image = UIImage(named: "emptyTable")
        emptyTableImageView.isHidden = true

        segmentedControl.selectedSegmentIndex = 0
        
        descriptionLabel.text = "You can search for task titles, notes, users using @, tags using #, checklist items, and much more."
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .systemGray

        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tableView.rowHeight = Layout.cellHeight

        loadingIndicator.color = .systemGray
    }

    private func setupConstraints() {
        [segmentedControl, descriptionLabel, tableView, emptyTableImageView, loadingIndicator].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subView)
        }

        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: rightAnchor),
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),

            emptyTableImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyTableImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: frame.width / 5),
            emptyTableImageView.heightAnchor.constraint(equalToConstant: frame.width / 2),
            emptyTableImageView.widthAnchor.constraint(equalToConstant: frame.width / 2),

            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
