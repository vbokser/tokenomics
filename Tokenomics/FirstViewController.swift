//
//  FirstViewController.swift
//  Tokenomics
//
//  Created by Vitaly Bokser on 7/19/18.
//  Copyright © 2018 Vitaly Bokser. All rights reserved.
//

import UIKit
import CryptoCurrencyKit

enum State {
    case GatheringData
    case DisplayData
}

class FirstViewController: UIViewController {
    @IBOutlet weak var cryptoTableView: UITableView!
    var cryptoArray = ["Bitcoin", "Ethereum", "Ripple"]
    var allTickers:[Ticker] = []
    var dataTimer = Timer()
    
    var indexPathsToReload = [IndexPath]()
    
    var currentState:State = State.DisplayData
    var updateCounter:Int = 0
    var numberOfTotalVisibleRows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cryptoTableView.delegate = self
        fetchTickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func getCryptoData() {
        print("In getCryptoData")
        //get data 1 ticker at a time
        
        if self.currentState == State.GatheringData {
            return
        }

        var indexPaths = self.cryptoTableView.indexPathsForVisibleRows
        
        
        if let indexPaths = indexPaths {
            self.numberOfTotalVisibleRows = indexPaths.count
//            print("Num visible rows = \(indexPaths.count)")
//            print("index 1 = \(indexPaths.first!)")
//            print("index last = \(indexPaths.last!)")
//            for index in indexPaths {
//                print"  seeing row = \(index.row)")
//            }
//            let currentCurrency:CryptoCurrencyKit.Money = .usd

            for index in indexPaths {
                var row = index.row
                
                CryptoCurrencyKit.fetchTicker(coinName: self.allTickers[row].id, convert: .usd) { r in
                    switch r {
                    case .success(let ticker):
                        //print(ticker)
                        print("--------")
                        print(" ticker.name = \(ticker.name)")
                        print(" index of ticker = \(self.allTickers.index(of: ticker))")
                        if let index = self.allTickers.index(of: ticker) {
                            print(" ticker found for index = \(self.allTickers[index])")
                            if ticker.id == self.allTickers[index].id {
                                //ok we have the same ticker thats now updated
                                self.allTickers[index] = ticker
                                
                                
//                                UIView.setAnimationsEnabled(false)
//                                self.cryptoTableView.beginUpdates()
                                
                                let reloadIndexPath = IndexPath(item: Int(index), section: 0)
                                self.indexPathsToReload.append(reloadIndexPath)

//                                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
//                                    withRowAnimation:UITableViewRowAnimationNone];
//                                self.cryptoTableView.endUpdates()
//                                UIView.setAnimationsEnabled(true)

                                self.updateCounter += 1
                                self.currentState = State.GatheringData
                                if self.updateCounter >= self.numberOfTotalVisibleRows {
                                    self.currentState = State.DisplayData
                                    self.updateCounter = 0
                                
                                    UIView.setAnimationsEnabled(false)
                                    self.cryptoTableView.beginUpdates()

                                    self.cryptoTableView.reloadRows(at: self.indexPathsToReload, with: .none)
                                    
                                    self.cryptoTableView.endUpdates()
                                    UIView.setAnimationsEnabled(true)
                                }
                            }
                        }

                    case .failure(let error):
                        print(error)
                    }
                }
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

                //setup timer if we fetched all the tickers
                self.dataTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getCryptoData), userInfo: nil, repeats: true)

            case .failure(let error):
                print(error)
            }
        }
    }


}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource
{
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
        print("Selected Row = \(row)")
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

