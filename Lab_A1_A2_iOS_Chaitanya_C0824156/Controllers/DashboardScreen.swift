//
//  DashboardScreen.swift
//  Lab_A1_A2_iOS_Chaitanya_C0824156
//
//  Created by Mac on 2021-09-21.
//

import UIKit
import CoreData
enum fetchType : String{
    case product = "product"
    case provider = "provider"
}
class DashboardScreen: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var homeTV: UITableView!
    @IBOutlet weak var selectSeg: UISegmentedControl!
    var arrProducts = [Products]()
    var arrProviders = [Providers]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAddData()
        self.title = "Products"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleSegChanged(selectSeg)
    }
    
    @IBAction func handleSegChanged(_ sender: UISegmentedControl) {
        fetchFromCoreData(for: sender.selectedSegmentIndex == 0 ? .product : .provider)
        
    }
    // Fetch Products or Providers from Coredata
    func fetchFromCoreData(for type : fetchType){
        if type == .product{
            if let result = Functions.getProducts(){
                arrProducts  = result
                self.title = "Products"
            }
        }
        else{
            if let result = Functions.getProviders(){
                arrProviders  = result
                self.title = "Providers"
            }
            
        }
        homeTV.reloadData()
    }
    //First Run
    func fetchAddData(){
        if let result = Functions.getProducts(){
            arrProducts  = result
        }
        else{
            // Add Temp Data
            let provider1 = Providers(context: Functions.context)
            provider1.providerName = "HomeMade"
            
            let provider2 = Providers(context: Functions.context)
            provider2.providerName = "FactoryMade"
            
            var product = Products(context: Functions.context)
            product.productID = "1"
            product.productName = "First Product"
            product.productDesc = "Small description for First Pr1"
            product.productPrice = "10.6"
            product.providers = provider1
           
            
            product = Products(context: Functions.context)
            product.productID = "2"
            product.productName = "Second Product"
            product.productDesc = "Small description for Second Pro1"
            product.productPrice = "5.7"
            product.providers = provider1
           
            
            product = Products(context: Functions.context)
            product.productID = "3"
            product.productName = "Third Product"
            product.productDesc = "Small description for Third Prod1"
            product.productPrice = "6.9"
            product.providers = provider1
           
            
            product = Products(context: Functions.context)
            product.productID = "4"
            product.productName = "Forth Product"
            product.productDesc = "Small description for Forth Produ1"
            product.productPrice = "9.5"
            product.providers = provider2
           
            
            product = Products(context: Functions.context)
            product.productID = "5"
            product.productName = "Fifth Product"
            product.productDesc = "Small description for Fifth Pro1"
            product.productPrice = "35.7"
            product.providers = provider1
           
            
            product = Products(context: Functions.context)
            product.productID = "6"
            product.productName = "Six Product"
            product.productDesc = "Small description for Six Prod1"
            product.productPrice = "16.9"
            product.providers = provider1
           
            
            product = Products(context: Functions.context)
            product.productID = "7"
            product.productName = "Seven Product"
            product.productDesc = "Small description for Seven Produ1"
            product.productPrice = "1.52"
            product.providers = provider2
           
            
            product = Products(context: Functions.context)
            product.productID = "8"
            product.productName = "Eight Product"
            product.productDesc = "Small description for Eight Pro1"
            product.productPrice = "50.7"
            product.providers = provider1
           
            
            product = Products(context: Functions.context)
            product.productID = "9"
            product.productName = "Nine Product"
            product.productDesc = "Small description for Nine Prod1"
            product.productPrice = "24.90"
            product.providers = provider1
            Functions.saveDataToCoreData()
            fetchAddData()
        }
        homeTV.reloadData()
    }
    @IBAction func handleAdd(_ sender: Any) {
            let vc = storyboard?.instantiateViewController(identifier: "ShowProductVC") as! ProductScreen
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension DashboardScreen : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            if selectSeg.selectedSegmentIndex == 0 {
                arrProducts = arrProducts.filter({
                    return ($0.productName!.lowercased().contains(searchText.lowercased())) || ($0.productDesc!.lowercased().contains(searchText.lowercased()))
                })
            }
            else{
                arrProviders = arrProviders.filter({
                    return ($0.providerName!.lowercased().contains(searchText.lowercased()))
                })
            }
            
        }
        else{
            self.fetchFromCoreData(for: self.selectSeg.selectedSegmentIndex == 0 ? .product : .provider)
        }
        homeTV.reloadData()
    }
}
extension DashboardScreen : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectSeg.selectedSegmentIndex == 0 ? arrProducts.count : arrProviders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if selectSeg.selectedSegmentIndex == 0{
            cell.textLabel?.text =
                arrProducts[indexPath.row].productName
            cell.detailTextLabel?.text = arrProducts[indexPath.row].providers?.providerName
        }
        else{
            cell.textLabel?.text = arrProviders[indexPath.row].providerName
            if let count = Functions.getProductsWithPredicate(predicate: NSPredicate(format: "providers.providerName = %@",arrProviders[indexPath.row].providerName!))?.count{
                cell.detailTextLabel?.text = "\(count)"
            }
            else{
                cell.detailTextLabel?.text = String(0)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectSeg.selectedSegmentIndex == 0 {
            let vc = storyboard?.instantiateViewController(identifier: "ShowProductVC") as! ProductScreen
            vc.product = arrProducts[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = storyboard?.instantiateViewController(identifier: "ProviderDetailVC") as! ProviderScreen
            vc.provider = arrProviders[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Warning", message: "You are about to delete this, Are you sure.", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if editingStyle == .delete{
                if self.selectSeg.selectedSegmentIndex == 0{
                    let objc = self.arrProducts[indexPath.row]
                    Functions.context.delete(objc)
                    Functions.saveDataToCoreData()
                }
                else{
                    for product in self.arrProducts{
                        if product.providers?.providerName == self.arrProviders[indexPath.row].providerName{
                            Functions.context.delete(product)
                        }
                    }
                    Functions.context.delete(self.arrProviders[indexPath.row])
                    Functions.saveDataToCoreData()
                    
                }
                self.fetchFromCoreData(for: self.selectSeg.selectedSegmentIndex == 0 ? .product : .provider)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
        
    }
}
