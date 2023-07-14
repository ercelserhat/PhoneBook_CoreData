//
//  KisiEkleViewController.swift
//  KisilerApp
//
//  Created by Serhat on 12.07.2023.
//

import UIKit

class KisiEkleViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var kisiAdiTextField: UITextField!
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func kisiEkleButton(_ sender: Any) {
        if let ad = kisiAdiTextField.text, let tel = kisiTelTextField.text{
            let kisi = Kisiler(context: context)
            kisi.kisi_ad = ad
            kisi.kisi_tel = tel
            appDelegate.saveContext()
        }
    }
}
