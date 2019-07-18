//
//  TopicosTableView.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 18/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class TopicosTableView: UITableView {

    var alturaMaxima: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let altura = min(contentSize.height, alturaMaxima)
        return CGSize(width: contentSize.width, height: altura)
    }

}
