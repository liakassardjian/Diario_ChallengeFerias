//
//  NotasTVCell.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 16/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class NotasTVCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView! {
        didSet {
            self.cardView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var tituloLabel: UILabel!
    
    @IBOutlet weak var corpoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
