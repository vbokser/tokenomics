//
//  FirstViewController.swift
//  Tokenomics
//
//  Created by Vitaly Bokser on 7/19/18.
//  Copyright © 2018 Vitaly Bokser. All rights reserved.
//

import UIKit
import CryptoCurrencyKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var cryptoTableView: UITableView!
    var cryptoArray = ["Bitcoin", "Ethereum", "Ripple"]

    var allTickers:[Ticker] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CRYPTO_CELL", for: indexPath)

        if allTickers.count <= 0 {
            return cell
        }
        
        let name = cell.viewWithTag(1000) as! UILabel
        let price = cell.viewWithTag(2000) as! UILabel
//        cell.textLabel?.text = cryptoArray[indexPath.row]

        let row = indexPath.row
        name.text = allTickers[row].name //cryptoArray[indexPath.row]
       
        if let priceVal = allTickers[row].priceUSD {
            price.text = "\(priceVal)"

        } else {
            price.text = "price unavailable"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.cryptoTableView.delegate = self
        fetchTickers()
//        getCryptoData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCryptoData() {
        CryptoCurrencyKit.fetchTicker(coinName: "BitCoin", convert: .usd) { r in
            switch r {
            case .success(let bitCoin):
                print(bitCoin)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchTickers() {
        CryptoCurrencyKit.fetchTickers { r in
            switch r {
            case .success(let tickers):
//                print(tickers)
                print("Num Ticker = \(tickers.count)")
                self.allTickers = []
                for ticker in tickers {
                    self.allTickers.append(ticker)
                }
                self.cryptoTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }


}

