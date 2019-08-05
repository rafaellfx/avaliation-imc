//
//  UsuariosViewController.swift
//  Projeto final IOS
//
//  Created by Rafael lima felix on 15/06/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import UIKit

class UsuariosViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    var refreshController: UIRefreshControl!
    var refrashing: Bool = false
    
    var users:[ User ] = []
    var userFind: [User] = []
    var searching: Bool = false
    
    let operation = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        search.delegate = self
        search.backgroundImage = UIImage()
        
        loadUsers()
        addRefresh()
        
    }
    
    func loadUsers(){
        self.refrashing = false
        HttpUsers.loadUsers { (users) in
            
            if let user = users {
                if user == self.users {
                    self.refrashing = true
                    OperationQueue.main.addOperation {
                        self.refreshList()
                        return
                    }
                    return
                }
                
                if user.count < self.users.count {
                    self.users = user
                    OperationQueue.main.addOperation {
                        self.tableView.reloadData()
                        self.refrashing = true
                    }
                }
                
                self.operation.addOperation {
                    user.forEach({ (user) in
                        for usr in self.users {
                            if user == usr {
                                self.refrashing = true
                                return
                            }
                        }
                        self.users.append(user)
                        OperationQueue.main.addOperation {
                            self.tableView.reloadData()
                            self.refrashing = true
                        }
                    })
                    
                    OperationQueue.main.addOperation {
                        self.refreshList()
                    }
                }
                
            }
        }
    }
    
    func addRefresh() {
        refreshController = UIRefreshControl()
        
        refreshController.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        tableView.addSubview(refreshController)
        
    }

    @objc func refreshList(){
        
        if refrashing {
            refreshController.endRefreshing()
            refrashing = false
        }else{
            self.loadUsers()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectedTableViewCell = tableView.indexPathForSelectedRow {
            var user: User
            if searching {
                 user = userFind[selectedTableViewCell.row]
            }else{
                 user = users[selectedTableViewCell.row]
            }
            
            let viewController = segue.destination as! ValuationsViewController
            viewController.user = user
        }
    }
    

}

extension UsuariosViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return userFind.count
        }
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUsers") as! UsuarioTableViewCell
        var user: User
        
        if searching {
            user = userFind[indexPath.row]
            print(user)
        }else {
            user = self.users[indexPath.row]
        }
        
        cell.lbName.text = user.name.uppercased()
        cell.lbCpf.text = "CPF: \(user.cpf)"
        cell.configure(userImage: user.image)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        if editingStyle == .delete {
            HttpUsers.delete(user: user) { (success) in
                if success {
                    self.users.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                    
                }
            }
        }
    }
    
}

extension UsuariosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        userFind = users.filter({$0.name.prefix(searchText.count).uppercased() == searchText.uppercased() || $0.cpf.prefix(searchText.count).uppercased() == searchText.uppercased()})
        searching = true
        tableView.reloadData()
    }
    
}
