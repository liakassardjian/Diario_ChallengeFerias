//
//  CardFixoCVCell.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 17/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class CardFixoCVCell: UICollectionViewCell {
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var topicosTableView: UITableView!
    @IBOutlet weak var adicionarButton: UIButton!
    
    @IBOutlet weak var cardView: UIView! {
        didSet {
            self.cardView.layer.cornerRadius = 10
        }
    }
    
}



extension CardFixoCVCell {
    func setTableViewDataSourceDelegate
        <D: UITableViewDelegate & UITableViewDataSource>
        (_ dataSourceDelegate: D, forRow row: Int)
    {
        topicosTableView.delegate = dataSourceDelegate
        topicosTableView.dataSource = dataSourceDelegate
        
        topicosTableView.reloadData()
    }
}
