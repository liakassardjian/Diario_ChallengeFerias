//
//  ListasTVController.swift
//  DiarioDeOracao
//
//  Created by Lia Kassardjian on 16/07/19.
//  Copyright © 2019 Lia Kassardjian. All rights reserved.
//

import UIKit

class ListasTVController: UITableViewController {

    var dados = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dados.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "topicos", for: indexPath) as? TopicosTVCell else {
            return UITableViewCell()
        }

        cell.tituloLabel.text = dados[indexPath.row]

        return cell
    }
    
    @IBAction func salvarNota(_ sender: UIStoryboardSegue) {}

}
