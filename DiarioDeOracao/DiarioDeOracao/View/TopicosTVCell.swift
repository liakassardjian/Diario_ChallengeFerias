//
//  TopicosTVCell.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 16/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class TopicosTVCell: UITableViewCell {

    @IBOutlet weak var checkView: UIView! {
        didSet {
            self.checkView.layer.borderWidth = 2
            self.checkView.layer.borderColor = #colorLiteral(red: 0.2812142968, green: 0.1408810616, blue: 0.2105534375, alpha: 1)
            self.checkView.layer.cornerRadius = 0.5 * checkView.frame.width
            self.checkView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var tituloLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
