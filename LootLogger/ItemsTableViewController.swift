//
//  ItemsTableViewController.swift
//  LootLogger
//
//  Created by Adrian Lesniak on 20/02/2021.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    var imageStore: ImageStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item = itemStore.items[indexPath.row]
        cell.nameLabel.text = item.isFavourite ? "\(item.name) - Favourite" : item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemToDelete = itemStore.items[indexPath.row]
            itemStore.removeItem(itemToDelete)
            imageStore.deleteImage(forKey: itemToDelete.itemKey)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let favouriteAction = UIContextualAction(style: .normal, title: "Favourite", handler: { [weak self] (action, view, completionHandler)  in
                            
            guard let item = self?.itemStore.items[indexPath.row] else {
                return
            }
            
            item.isFavourite = true
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        })
        
        favouriteAction.backgroundColor = .blue
        
        return UISwipeActionsConfiguration(actions: [favouriteAction])
    }
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        let newItem = itemStore.createItem()
        
        if let index = itemStore.items.firstIndex(of: newItem) {
            
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .right)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            
            guard let row = tableView.indexPathForSelectedRow?.row else { return }
            
            let detail = segue.destination as! DetailViewController
            detail.item = itemStore.items[row]
            detail.imageStore = imageStore
        }
    }
    
}
