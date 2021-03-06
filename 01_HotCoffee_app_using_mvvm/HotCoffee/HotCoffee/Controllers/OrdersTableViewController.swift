//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by chu on 2019/05/23.
//  Copyright © 2019 chu. All rights reserved.
//

import Foundation
import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOrders()
    }
    
    private func populateOrders() {
        Webservice().load(resource: Order.all) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init) // convert [Order] to [OrderViewModel]
                self?.tableView?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - UITableViewController delegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        return cell
    }
}

extension OrdersTableViewController : AddCoffeeOrderDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            let navC = segue.destination as? UINavigationController,
            let addCoffeeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
                fatalError("Error performing segue!")
        }
        
        addCoffeeOrderVC.delegate = self
    }
    
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
        
    }
    
    func addCoffeeORderViewControllerDidClose(controller: UIViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

