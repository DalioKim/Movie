//
//  ThumbnailListTableViewController.swift
//  CleanYTBPTJ
//
//  Created by 김동현 on 2022/01/05.
//

import UIKit

class ThumbnailListTableViewController: UITableViewController {
    
    var viewModel: ImagesListViewModel!

    var thumbnailRepository: ThumbnailRepository?
    var nextPageLoadingSpinner: UIActivityIndicatorView?
    


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }




    // MARK: - Private

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ThumbnailListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        printIfDebug("tableView")
        let cell = tableView.dequeueReusableCell(withIdentifier: ThumbnailListItemCell.reuseIdentifier) as! ThumbnailListItemCell
        
        
        
        cell.fill(with: viewModel.items.value[indexPath.row], thumbnailRepository: thumbnailRepository)


        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
