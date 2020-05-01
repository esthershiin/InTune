//
//  DashboardViewController.swift
//  InTune
//
//  Created by Allyson on 4/23/20.
//

import UIKit

class DashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        incomingRequests.delegate = self
        incomingRequests.dataSource = self
        pendingRequests.delegate = self
        pendingRequests.dataSource = self
        matches.delegate = self
        matches.dataSource = self
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var incomingRequests: UICollectionView!
    
    @IBOutlet weak var pendingRequests: UICollectionView!
    
    @IBOutlet weak var matches: UITableView!
    
    @IBAction func inviteButtonPressed(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
