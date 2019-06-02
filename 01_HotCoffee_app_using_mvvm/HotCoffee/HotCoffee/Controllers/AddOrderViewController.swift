//
//  AddOrderViewController.swift
//  HotCoffee
//
//  Created by chu on 2019/05/23.
//  Copyright © 2019 chu. All rights reserved.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController)
    func addCoffeeORderViewControllerDidClose(controller: UIViewController)
}

class AddOrderViewController: UIViewController {
    
    var delegate: AddCoffeeOrderDelegate?
    
    private var vm = AddCoffeeOrderViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        self.coffeeSizesSegmentedControl = UISegmentedControl(items: self.vm.sizes)
        self.coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 32).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @IBAction func save() {
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("Error in selecting coffee!")
        }
        
        self.vm.name = name
        self.vm.email = email
        self.vm.selectedSize = selectedSize
        self.vm.selectedType = self.vm.types[indexPath.row]
        
        Webservice().load(resource: Order.create(vm: self.vm)) { result in
            switch result {
            case .success(let order):
                DispatchQueue.main.async {
                    self.delegate?.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                }
            case .failure(let error):
                break
            }
        }
    }
    
    @IBAction func close() {
        self.delegate?.addCoffeeORderViewControllerDidClose(controller: self)
    }
}

extension AddOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        cell.textLabel?.text = self.vm.types[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
