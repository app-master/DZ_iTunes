//
//  SearchListViewController.swift
//  DZ_iTunes
//
//  Created by user on 27/05/2019.
//  Copyright © 2019 Sergey Koshlakov. All rights reserved.
//

import UIKit

class SearchListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        searchController = UISearchController(searchResultsController: nil)
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        
        tableView.tableHeaderView = searchBar
        
    }
    
    private func fetchData(searchParams: [String : String]) {
        guard let url = URL(string: "https://itunes.apple.com/search") else { return }
        
        guard let queryURL = url.urlWithQueryItems(for: searchParams) else { return }
        
        ServerManager.manager.fetchData(from: queryURL){(result, error) in
            guard let songs = result else { return }
            self.songs = songs
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureCell(cell: UITableViewCell, with indexPath: IndexPath) {
        
        let song = songs[indexPath.row]
        
        cell.textLabel?.text = song.trackName
        cell.detailTextLabel?.text = song.artistName
        
        ServerManager.manager.loadImage(from: song.imageUrl) { image in
            DispatchQueue.main.async {
                cell.imageView?.image = image
                cell.layoutSubviews()
                cell.layoutIfNeeded()
            }
        }
    }

}

extension SearchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "SongCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .value2, reuseIdentifier: identifier)
        }
        
        configureCell(cell: cell!, with: indexPath)
        
        return cell!
    }
    
}

extension SearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
       let vc = storyboard.instantiateViewController(withIdentifier: "SongViewController") as! SongViewController
    
        let song = songs[indexPath.row]
        vc.song = song
        
       navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension SearchListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, text.count > 0 else { return }
        
        let newText = text.reduce("") { (result, character) -> String in
            if character == " " {
                return result + String("+")
            }
            return result + String(character)
        }
        
        let params = [
            "term" : newText,
            "country" : "RU"
        ]
        
        fetchData(searchParams: params)
    }
    
}
