//
//  UsuarioTableViewCell.swift
//  Projeto final IOS
//
//  Created by Rafael lima felix on 15/06/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import UIKit

class UsuarioTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbCpf: UILabel!
    @IBOutlet weak var vCell: UIView!
    
    let operation = OperationQueue()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vCell.layer.cornerRadius = 10
        vCell.layer.masksToBounds = true
        
        imgUser.layer.cornerRadius = 42
        imgUser.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        operation.cancelAllOperations()
    }
    
    func configure(userImage: String) {
        imgUser.image = UIImage(named: "placeholder")
        self.operation.addOperation {
            do{
                let uri = URL(string: "http://rafaellfx.com.br/api-ios/img/" + userImage)
                let data = try Data(contentsOf: uri!)
                OperationQueue.main.addOperation {
                    self.imgUser.image = UIImage(data: data)
                }
                
            }catch{
                print("error")
            }
        }
    }
    
    
}
