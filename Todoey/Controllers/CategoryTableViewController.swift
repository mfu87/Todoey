//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Marcus Fuchs on 14.07.19.
//  Copyright © 2019 Marcus Fuchs. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    
    //MARK: Gloabl Variables:

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    
//------------------------------------------------------------------------------------------------------------------------------------------------

 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
  
    
//------------------------------------------------------------------------------------------------------------------------------------------------

    //MARK: - Data Manipulation Methods
    
    func loadCategories() {
        
        //create a request that fetches ALL data:
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading Categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    func saveCategories() {
        
        do {
            try context.save()
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

}
