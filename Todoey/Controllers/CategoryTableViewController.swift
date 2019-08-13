//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Marcus Fuchs on 14.07.19.
//  Copyright © 2019 Marcus Fuchs. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    
    //MARK: Gloabl Variables:
    
    let realm = try! Realm()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
//------------------------------------------------------------------------------------------------------------------------------------------------

 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.saveCategories(category: newCategory)
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add a new Category"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

    
//------------------------------------------------------------------------------------------------------------------------------------------------

    
    //MARK: - TableView Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        //means: if categories is nil return 1, else return categories.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"
        
        return cell
    }
    
    
//------------------------------------------------------------------------------------------------------------------------------------------------

    //MARK: - Data Manipulation Methods
    
    func loadCategories() {
        
        //pulls out all Objects of type Category from our Realm
        categories = realm.objects(Category.self)
        //retrun type is of type "Results" from Realm
        
        tableView.reloadData()
    }
    
    
    func saveCategories(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
//------------------------------------------------------------------------------------------------------------------------------------------------

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        //find out what is the selected cell / "indexPathForSelectedRow" is an Optional -> wrapped in if/let
        if let indexPath = tableView.indexPathForSelectedRow {
            
            //hier wird die category property des ToDoListVC gleich der getappten category des CategoryVC gesetzt
            //selectedCategory kann nicht als String gesetzt werden, da die "relationship", welche im data model erstellt wurde, ein catergory? ist
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

}
