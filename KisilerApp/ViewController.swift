//
//  ViewController.swift
//  KisilerApp
//
//  Created by Serhat on 12.07.2023.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var kisilerTableView: UITableView!
    
    var kisilerListe = [Kisiler]()
    
    var aramaYapiliyormu = false
    var aramaKelimesi: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kisilerTableView.dataSource = self
        kisilerTableView.delegate = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if aramaYapiliyormu{
            aramaYap(kisiAdi: aramaKelimesi!)
        }else{
            tumKisileriAl()
        }
        kisilerTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        
        if segue.identifier == "toKisiDetay"{
            let destinationVC = segue.destination as! KisiDetayViewController
            destinationVC.kisi = kisilerListe[indeks!]
        }
        if segue.identifier == "toKisiGuncelle"{
            let destinationVC = segue.destination as! KisiGuncelleViewController
            destinationVC.kisi = kisilerListe[indeks!]
        }
    }
    
    func tumKisileriAl(){
        do{
            kisilerListe = try context.fetch(Kisiler.fetchRequest())
        }catch{
            print(error)
        }
    }
    
    func aramaYap(kisiAdi: String){
        let fetchRequest: NSFetchRequest<Kisiler> = Kisiler.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kisi_ad CONTAINS %@", kisiAdi)
        do{
            kisilerListe = try context.fetch(fetchRequest)
        }catch{
            print(error)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kisilerListe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kisi = kisilerListe[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "kisiHucre", for: indexPath) as! KisiHucreTableViewCell
        cell.kisiYaziLabel.text = "\(kisi.kisi_ad!) - \(kisi.kisi_tel!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toKisiDetay", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil") { contextualaction, view, boolValue in
            let kisi = self.kisilerListe[indexPath.row]
            self.context.delete(kisi)
            appDelegate.saveContext()
            if self.aramaYapiliyormu{
                self.aramaYap(kisiAdi: self.aramaKelimesi!)
            }else{
                self.tumKisileriAl()
            }
            self.kisilerTableView.reloadData()
        }
        let guncelleAction = UIContextualAction(style: .normal, title: "Güncelle") { contextualaction, view, boolValue in
            self.performSegue(withIdentifier: "toKisiGuncelle", sender: indexPath.row)
        }
        return UISwipeActionsConfiguration(actions: [silAction, guncelleAction])
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Arama sonuç: \(searchText)")
        
        aramaKelimesi = searchText
        if searchText == ""{
            aramaYapiliyormu = false
            tumKisileriAl()
        }else{
            aramaYapiliyormu = true
            aramaYap(kisiAdi: aramaKelimesi!)
        }
        kisilerTableView.reloadData()
    }
}

