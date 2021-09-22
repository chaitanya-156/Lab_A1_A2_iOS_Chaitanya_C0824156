//
//  ShowProductVC.swift
//  Lab_A1_A2_iOS_Chaitanya_C0824156
//
//  Created by Mac on 2021-09-21.
//

import UIKit

class ProductScreen: UIViewController {
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtPPrice: UITextField!
    @IBOutlet weak var txtPProvider: UITextField!
    @IBOutlet weak var txtPDesc: UITextField!
    @IBOutlet weak var txtPName: UITextField!
    var product : Products?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product{
            txtID.text = product.productID
            txtPPrice.text = product.productPrice
            txtPProvider.text = product.providers?.providerName
            txtPDesc.text = product.productDesc
            txtPName.text = product.productName
            self.title = "Show Products"
        }
        else{
            self.title = "Add Product"
        }
        
    }
    @IBAction func handleAdd(_ sender: Any) {
        guard let txtProvider = txtPProvider.text.self else {
            return
        }
        let localProvider = Functions.getProvidersWithPredicate(predicate: NSPredicate(format: "providerName = '\(txtProvider)'"))
        var provider : Providers!
        if localProvider?.count == 0 || localProvider == nil {
            provider = Providers(context: Functions.context)
            provider.providerName = txtProvider
        }
        else{
            provider = localProvider![0]
        }
        if let product = self.product != nil ? self.product : Products(context: Functions.context){
            product.productID = txtID.text
            product.productPrice = txtPPrice.text
            product.providers = provider
            product.productDesc = txtPDesc.text
            product.productName = txtPName.text
        }
        Functions.saveDataToCoreData()
        self.navigationController?.popViewController(animated: true)
    }
}
