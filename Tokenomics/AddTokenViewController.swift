//
//  AddTokenViewController.swift
//  Tokenomics
//
//  Created by Vitaly Bokser on 7/25/18.
//  Copyright © 2018 Vitaly Bokser. All rights reserved.
//

import UIKit

class AddTokenViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let cellId = "TokenCell"
    
    var tokenArray = [Token]()
    var currentTokenArray = [Token]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTokenArray()
        setupSearchBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func setupTokenArray()
    {
        tokenArray.append(Token(name: "Bitcoin", price: 6800, marketCap: 126000000000))
        tokenArray.append(Token(name: "Etherium", price: 6800, marketCap: 126000000000))
        tokenArray.append(Token(name: "Litecoin", price: 6800, marketCap: 126000000000))
        tokenArray.append(Token(name: "XRP", price: 6800, marketCap: 126000000000))

        currentTokenArray = tokenArray
    }
    
    private func setupSearchBar() {
        
    }
}

extension AddTokenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //reset tokens if search field is empty
        print("searchText = \(searchText)")
//        guard !searchText.isEmpty else {
//            currentTokenArray = tokenArray
//            tableView.reloadData()
//            return
//        }
        
//        currentTokenArray = tokenArray //lets search through entire array

        currentTokenArray = tokenArray.filter({ (token) -> Bool in
            guard let text = searchBar.text else { return false }
            let lower_token = token.name.lowercased()
            let lower_text = text.lowercased()
            return lower_token.contains(lower_text)
        })
        tableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        
//        
//    }
}

extension AddTokenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTokenArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = currentTokenArray[row].name

        return cell
    }
    
}
