//
//  ViewController.swift
//  Todoist
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var elementOfItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectCategory: Category? {
        didSet{  // selectCategory changed from oldValue to newValue
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .white
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementOfItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = elementOfItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.check ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Item Yet"
        }
        
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    // MARK: - TableView Delgate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = elementOfItems?[indexPath.row] {
            
            do {
                try realm.write{
                    item.check = !item.check
                }
            }catch {
                print("Error when updating elements \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Delet Item From elementItemCell
    
    override func deleteElementFromCell(at indexPath: IndexPath) {
        do {
            try self.realm.write{
                self.realm.delete((self.elementOfItems?[indexPath.row])!)
            }
        }catch{
            print("Error when delet category \(error)")
        }
    }
        
        // MARK: - Add new item
        
        @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                
                if let currentCategory = self.selectCategory {
                    do {
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch {
                        print("Error when save new items in realm\(error)")
                    }
                    // newItem.parentCategory = self.selectCategory
                }
                self.tableView.reloadData()
            }
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "Create new item"
                textField = alertTextField
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
        
        // MARK: - Model Manupulation Methods
        
        func loadItems (){
            
            elementOfItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
        
    }
    
    // MARK: - Search bar methods
    
    extension ToDoListViewController: UISearchBarDelegate{
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            elementOfItems = elementOfItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
            
        }
    }
    

