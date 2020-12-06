//
//  TextsViewController.swift
//  oleg-verificator-example
//
//  Created by Oleg Voitenko on 06.12.2020.
//

import Foundation
import UIKit

class TextsViewController: UITableViewController {
    private let viewModel: TextsViewModelType
    init(viewModel: TextsViewModelType) {
        self.viewModel = viewModel
        super.init(style: .plain)
        title = viewModel.title
        tableView.separatorColor = UIColor(hexString: "B8E0DD")
        view.backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.texts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "TextsCellIdentifier"
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        cell.textLabel?.text = viewModel.texts[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
