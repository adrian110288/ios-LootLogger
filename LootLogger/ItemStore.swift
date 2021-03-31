//
//  ItemStore.swift
//  LootLogger
//
//  Created by Adrian Lesniak on 20/02/2021.
//

import Foundation
import UIKit

class ItemStore {
    
    var items = [Item]()
    var over50 = [Item]()
    var rest = [Item]()
    
    private let itemArchiveURL: URL = {
        let docDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectory = docDirectories.first!
        return docDirectory.appendingPathComponent("items.plist")
    }()
    
    init() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(saveChangs), name: UIScene.didEnterBackgroundNotification, object: nil)
        
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            
            self.items = items
        } catch {
            print("Error reading in saved items: \(error)")
        }
    }
    
    @discardableResult
    func createItem() -> Item {
        let item = Item(random: true)
        items.append(item)
        
        if (item.valueInDollars >= 50) {
            over50.append(item)
        } else {
            rest.append(item)
        }
        
        return item
    }
    
    func removeItem(_ item: Item) {
        
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
        
        if let index = over50.firstIndex(of: item) {
            over50.remove(at: index)
        }
        
        if let index = rest.firstIndex(of: item) {
            rest.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        
        if fromIndex == toIndex {
            return
        }
        
        let itemToMove = items[fromIndex]
        removeItem(itemToMove)
        items.insert(itemToMove, at: toIndex)
    }
    
    @objc func saveChangs() -> Bool {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(items)
            try data.write(to: itemArchiveURL, options: .atomic)
            print(itemArchiveURL)
        } catch {
            
        }
        
        return false
    }
}
