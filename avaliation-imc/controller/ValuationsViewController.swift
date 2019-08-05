//
//  AvaliacoesViewController.swift
//  Projeto final IOS
//
//  Created by Rafael lima felix on 15/06/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import UIKit

class ValuationsViewController: UIViewController {

    
    @IBOutlet weak var nvNome: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searching: Bool = false
    var valuationsFind: [Valuation] = []
    var valuations: [Valuation] = []
    var user:User?
    let operation = OperationQueue()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = user else {return}
        title = user.name.uppercased()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        searchBar.backgroundImage = UIImage()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadValuations()
    }
    
    func loadValuations(){
        if let user = user {
            HttpValuations.loadValuations(user.id) { (validations) in
                
                if let validations = validations {
                    
                    self.operation.addOperation {
                        
                        self.valuations = validations
                        OperationQueue.main.addOperation {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newValuation"{
            let avaliacao = segue.destination as! AvaliacaoViewController
            avaliacao.user = user
        }
        
    }

}

extension ValuationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return valuationsFind.count
        }
        return valuations.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "avaliacaoCell") as! ValuationTableViewCell
        
        let valuation: Valuation
        
        if searching {
            valuation = valuationsFind[indexPath.row]
        }else {
            valuation = valuations[indexPath.row]
        }
        
        cell.lbWeight.text = String(valuation.weight)
        cell.lbHeight.text = String(valuation.height)
        cell.lbIMC.text    = String(Int(valuation.imc))
        cell.lbResult.text = valuation.result
        cell.lbDate.text   = valuation.date
        
        cell.imgResult.image = UIImage(named: valuation.image)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let valuation = valuations[indexPath.row]
        if editingStyle == .delete {
            HttpValuations.delete(valuation: valuation) { (success) in
                if success {
                    self.valuations.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                }
            }
        }
    }
    
    
}


extension ValuationsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        valuationsFind = valuations.filter({
            $0.weight.description.prefix(searchText.count).uppercased() == searchText.uppercased() ||
            $0.height.description.prefix(searchText.count).uppercased() == searchText.uppercased() ||
            $0.result.prefix(searchText.count).uppercased() == searchText.uppercased() ||
            $0.date.prefix(searchText.count).uppercased() == searchText.uppercased()
                
        })
        searching = true
        tableView.reloadData()
    }
    
}
