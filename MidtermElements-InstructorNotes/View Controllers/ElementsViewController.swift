//
//  ElementsViewController.swift
//  MidtermElements-InstructorNotes
//
//  Created by C4Q  on 12/7/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ElementsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var elements = [Element]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        loadData()
    }
    
    func loadData() {
        ElementAPIClient.shared.getElements(from: "https://api.fieldbook.com/v1/5a29757f9b3fec0300e1a68c/elements", completionHandler: {
            self.elements = $0
            self.tableView.reloadData()
        }, errorHandler: {print($0)})
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ElementDetailViewController {
            if let row = self.tableView.indexPathForSelectedRow?.row {
                destination.element = self.elements[row]
            }
        }
    }
}

extension ElementsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.elements.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "Element Cell", for: indexPath) as? ElementTableViewCell else {
            return UITableViewCell()
        }
        cell.nameLabel.text = element.name
        cell.symbolWeightLabel.text = "Atomic Number \(element.number)"
        var numberAsStr = "\(element.number)"
        while numberAsStr.count < 3 {
            numberAsStr = "0" + numberAsStr
        }
        let thumbnailStr = "http://www.theodoregray.com/periodictable/Tiles/\(numberAsStr)/s7.JPG"
        cell.elementImageView?.image = nil
        ImageAPIClient.manager.loadImage(from: thumbnailStr, completionHandler: {
            cell.elementImageView.image = $0
            cell.elementImageView.setNeedsLayout()
        }, errorHandler: {print($0)})
        return cell
    }
}
