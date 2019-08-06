//
//  ViewController.swift
//  Todoey
//
//  Created by Marcus Fuchs on 06.07.19.
//  Copyright © 2019 Marcus Fuchs. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
    //MARK: Gloabl Variables:
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        //didSet wird ausgeführt wenn die Variable gesetzt wird (hier: wenn eine Catergory getapped wird)
        didSet {
            loadItems()
            print(selectedCategory!)
        }
    }
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
//------------------------------------------------------------------------------------------------------------------------------------------------

    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //add/removes checkmark in View
        //Ternary operator (instead of if-statement):     value = condition ? valueIfTrue: valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
//------------------------------------------------------------------------------------------------------------------------------------------------
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //toggle done property changed with clicking cell + save change in Array
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //to change title:
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //to delete items || 1st: remove it from context (removes it in sqlite) / 2nd: remove from Array (does nothing on core data)
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.saveItems()
        
        //highlights cell only shortly when tapped (otherwise cell stays grey until new cell selected:
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
//------------------------------------------------------------------------------------------------------------------------------------------------

    //MARK: Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //name and look of popup
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        //button and following action on Pop-Up
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once user clicks Add Item Button on our alert
            
            let newItem = Item(context: self.context) //Item from CoreData Class now
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        //add textfiled to alert
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create New Item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
//------------------------------------------------------------------------------------------------------------------------------------------------

    //MARK: Model Manupulation Methods
    
    func saveItems() {
        

        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    //external parameter: "with" / internal: "request" || default value if no arguments given to func is "Item.fetchRequest() + no predicate"
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //zusammengesetztes Predicate wird erstellt: beihaltet das übergebene "Predicate" der search sowie das "categoryPredicate"
        
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        //
        //        request.predicate = compoundPredicate
        
       
        //as predicate is Optional we need to savely unwrapp it
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }

        tableView.reloadData()
    }
    
}


//------------------------------------------------------------------------------------------------------------------------------------------------

    //MARK: Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //NSPredicate is a foundation class that specifies how data should be fetched or filtered / basicly a query language
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        //sort results:
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        //start request:
        loadItems(with: request, predicate: predicate)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            //no more keyboard / cursore dissapears
            //DispatchQueue: manager who assignes projetcs to diff threads
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
        }
    }
    
    

}

