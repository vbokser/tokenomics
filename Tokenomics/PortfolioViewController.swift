//
//  SecondViewController.swift
//  Tokenomics
//
//  Created by Vitaly Bokser on 7/19/18.
//  Copyright © 2018 Vitaly Bokser. All rights reserved.
//

import UIKit
import CryptoCurrencyKit

enum PortfolioLabelIds: Int {
    case name = 1000
    case price = 2000
    case numTokens = 3000
    case totalPrice = 4000
    case marketCap = 5000
}

class PortfolioViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "PortfolioCell"
    let portfolio = ["Bitcoin","XRP"]
    var allTickers:[Ticker] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTickersFromPortfolio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    private func fetchTickersFromPortfolio() {
    
    }
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let row = indexPath.row
        
        let name = cell.viewWithTag(PortfolioLabelIds.name.rawValue) as! UILabel
        let price = cell.viewWithTag(PortfolioLabelIds.price.rawValue) as! UILabel
        let numTokens = cell.viewWithTag(PortfolioLabelIds.numTokens.rawValue) as! UILabel
        let totalPrice = cell.viewWithTag(PortfolioLabelIds.totalPrice.rawValue) as! UILabel
        let marketCap = cell.viewWithTag(PortfolioLabelIds.marketCap.rawValue) as! UILabel

        name.text = portfolio[row]
        price.text = "$10"
        numTokens.text = "100 XRP"
        totalPrice.text = "$1000"
        marketCap.text = "$3000"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
