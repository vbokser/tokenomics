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

enum TableCellTagValues:Int {
    case rank = 10
    case assetName = 20
    case price = 30
    case marketCap = 40
}

class AllAssetsViewController: UIViewController {
    @IBOutlet weak var cryptoTableView: UITableView!
    var cryptoArray = ["Bitcoin", "Ethereum", "Ripple"]
    var allTickers:[Ticker] = []
    var dataTimer = Timer()
    
    var indexPathsToReload = [IndexPath]()
    
    var currentState:State = State.DisplayData
    var updateCounter:Int = 0
    var numberOfTotalVisibleRows: Int = 0
    
    var cellHeights: [IndexPath : CGFloat] = [:]

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

        let indexPaths = self.cryptoTableView.indexPathsForVisibleRows
        
        
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
                let row = index.row
                
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
                                
//                                    UIView.setAnimationsEnabled(false)
                                    UIView.performWithoutAnimation {
                                        self.cryptoTableView.beginUpdates()
                                        DispatchQueue.main.async {
                                            self.cryptoTableView.reloadData()
                                        }
                                        self.cryptoTableView.endUpdates()
                                    }
//                                    self.cryptoTableView.beginUpdates()
//                                    self.cryptoTableView.reloadRows(at: self.indexPathsToReload, with: .none)
//                                    DispatchQueue.main.async {
//                                        self.cryptoTableView.reloadData()
//                                    }
//                                    self.cryptoTableView.endUpdates()
//                                    UIView.setAnimationsEnabled(true)
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

                DispatchQueue.main.async {
                    self.cryptoTableView.reloadData()
                }

                //setup timer if we fetched all the tickers
                self.dataTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.getCryptoData), userInfo: nil, repeats: true)

            case .failure(let error):
                print(error)
            }
        }
    }


}

extension AllAssetsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTickers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CRYPTO_CELL", for: indexPath)
        
        if allTickers.count <= 0 {
            return cell
        }
        
        let rank = cell.viewWithTag(TableCellTagValues.rank.rawValue) as! UILabel
        let name = cell.viewWithTag(TableCellTagValues.assetName.rawValue) as! UILabel
        let price = cell.viewWithTag(TableCellTagValues.price.rawValue) as! UILabel
        let marketcap = cell.viewWithTag(TableCellTagValues.marketCap.rawValue) as! UILabel

        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency

        //        cell.textLabel?.text = cryptoArray[indexPath.row]
        
        let row = indexPath.row
        name.text = allTickers[row].name //cryptoArray[indexPath.row]
        
        if let priceVal = allTickers[row].priceUSD {
            //price.text = "\(priceVal)"
            if priceVal < 1.0 {
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 5
            }
            else {
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
            }
            
            if let formattedPrice = formatter.string(from: priceVal as NSNumber) {
                price.text = "\(formattedPrice)"
            }

        } else {
            price.text = "price unavailable"
        }
        
        rank.text = "\(allTickers[row].rank)"
        if let marketcapVal = allTickers[row].marketCapUSD {
//            marketcap.text = "MktCap: $\(marketcapVal)"
            
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2

            if let formattedMarketCapAmount = formatter.string(from: marketcapVal as NSNumber) {
                marketcap.text = "MarketCap: \(formattedMarketCapAmount)"
            }

        }
        
//        price.setTextAnimation(text: price.text, color: UIColor.green, duration: 1.0) {
//            //price.setTextAnimation(text: nil, color: UIColor.white, duration: 1.0)
//        }

        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60.0
//    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height+5
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeights[indexPath] else { return 70.0 }
        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        print("Selected Row = \(row)")
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension UILabel {
    /**
     Set Text With animation
     
     - parameter text:     String?
     - parameter duration: NSTimeInterval?
     */
    public func setTextAnimation(text: String? = nil, color: UIColor? = nil, duration: TimeInterval?, completion:(()->())? = nil) {
        UIView.transition(with: self, duration: duration ?? 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
            self.text = text ?? self.text
            self.textColor = color ?? self.textColor
        }) { (finish) in
            if finish { completion?() }
        }
    }
}

