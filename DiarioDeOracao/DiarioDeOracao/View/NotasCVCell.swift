//
//  NotasCVCell.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 17/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class NotasCVCell: UICollectionViewCell {
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var corpoLabel: UILabel!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            self.cardView.layer.cornerRadius = 10
        }
    }
}
