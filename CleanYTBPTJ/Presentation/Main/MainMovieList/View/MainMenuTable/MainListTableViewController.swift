//
//  MainListTableViewController.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2021/11/28.
//

import UIKit

class MainListTableViewController: UITableViewController {

    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
}

    // MARK: - UITableViewDataSource, UITableViewDelegate

    extension MainListTableViewController {

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
            //viewModel.items.value.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainListItemCell.reuseIdentifier,
                                                           for: indexPath) as? MainListItemCell else {
                assertionFailure("Cannot dequeue reusable cell \(MainListItemCell.self) with reuseIdentifier: \(MainListItemCell.reuseIdentifier)")
                return UITableViewCell()
            }

            cell.fill(index: indexPath.row)

           

            return cell
        }

//        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
//        }
//
//        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            viewModel.didSelectItem(at: indexPath.row)
//        }
    }

