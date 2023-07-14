//
//  KisiGuncelleViewController.swift
//  KisilerApp
//
//  Created by Serhat on 12.07.2023.
//

import UIKit

class KisiGuncelleViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var kisiAdiTextField: UITextField!
    @IBOutlet weak var kisiTelTextField: UITextField!
    
    var kisi: Kisiler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let k = kisi{
            kisiAdiTextField.text = k.kisi_ad
            kisiTelTextField.text = k.kisi_tel
        }
    }
    
    @IBAction func kisiGuncelleButton(_ sender: Any) {
        if let k = kisi, let ad = kisiAdiTextField.text, let tel = kisiTelTextField.text{
            k.kisi_ad = ad
            k.kisi_tel = tel
            appDelegate.saveContext()
        }
    }
}
