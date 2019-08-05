//
//  AvaliacaoTableViewCell.swift
//  Projeto final IOS
//
//  Created by Rafael lima felix on 15/06/19.
//  Copyright © 2019 rafaellfx. All rights reserved.
//

import UIKit

class ValuationTableViewCell: UITableViewCell {

    @IBOutlet weak var avaliationCell: UIView!
    @IBOutlet weak var imgResult: UIImageView!
    @IBOutlet weak var lbWeight: UILabel!
    @IBOutlet weak var lbHeight: UILabel!
    @IBOutlet weak var lbIMC: UILabel!
    @IBOutlet weak var lbResult: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avaliationCell.layer.cornerRadius = 10
        avaliationCell.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
