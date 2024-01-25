//
//  CategoryViewController.swift
//  Todoist
//
//  Created by mahmoud on 13/09/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController  {
    
    let realm = try! Realm()
    
    var Categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.rowHeight = 70
    }
    
    // MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = Categories?[indexPath.row].name ?? "No Categories Added"
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        return cell
    }
    
    
    // MARK: - Table View Delegate Methode
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = Categories?[indexPath.row]
        }
    }
    // MARK: - Data Manipulation Methods
    
    func saveCategories (category: Category){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print ("Error when save Category \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        Categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    override func deleteElementFromCell(at indexPath: IndexPath) {
        do {
            try self.realm.write{
                self.realm.delete((self.Categories?[indexPath.row])!)
            }
        }catch{
            print("Error when delet category \(error)")
        }
    }
    
    // MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        present(alert, animated: true)
    }
}


