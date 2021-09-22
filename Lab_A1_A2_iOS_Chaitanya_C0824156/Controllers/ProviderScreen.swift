//
//  ProviderScreen.swift
//  Lab_A1_A2_iOS_Chaitanya_C0824156
//
//  Created by Mac on 2021-09-21.
//

import UIKit

class ProviderScreen: UITableViewController {
    var provider : Providers!
    var products : [Products]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Details"
        if let _ = provider{
            products = Functions.getProductsWithPredicate(predicate: NSPredicate(format: "providers.providerName = %@",provider!.providerName!))
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = products?[indexPath.row].productName
        cell.detailTextLabel?.text = products?[indexPath.row].productDesc
        return cell
        
    }
}
