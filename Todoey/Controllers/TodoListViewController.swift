//
//  ViewController.swift
//  Todoey
//
//  Created by Edy on 3/14/18.
//  Copyright © 2018 Edy. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(dataFilePath)
        
      
        
        loadItems()
    }

  
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator ==>
        // value = condition ? valueifTure : valueifFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // for row selelction
        
       // print(itemArray[indexPath.row])
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark // after selection row it show selected sign
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // this single line repalces if statements below
        
        saveItems()
        
//        if  itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//
//        } else {
//
//            itemArray[indexPath.row].done = false
//
//        }
        
        
        
        
        tableView.deselectRow(at: indexPath, animated: true) // after selection grey fade away
        
        
    }
    
   
    //MARK - add New items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add item button on our Alert
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
           // self.defaults.set(self.itemArray, forKey: "TodoListArray") this is for standart plist
            
            self.saveItems()
            
        }
        
        //add textfield to alert
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            
            print("Error encoding item array, \(error)")
            
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array \(error)")
            }
        }
    }
    
}

