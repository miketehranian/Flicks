//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Mike Tehranian on 10/15/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var networkErrorView: UIView!
    
    var endpoint: String!
    
    var searchBar: UISearchBar!
    var filteredData: [NSDictionary]?
    var searchInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkErrorView.isHidden = true
        networkErrorView.frame.size.height = 0
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Load the table model
        networkRequest()
        
        // Attach the refresh control to the table view
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(networkRequest), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        
        // Initialize the filter movies list with the full list of movies
        filteredData = movies
    }
    
    func networkRequest() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    
                    self.movies = (responseDictionary["results"] as! [NSDictionary])
                    self.tableView.reloadData()
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.refreshControl.endRefreshing()
                    self.networkErrorView.isHidden = true
                    self.networkErrorView.frame.size.height = 0
                }
            } else {
                // Network Error
                self.networkErrorView.isHidden = false
                self.networkErrorView.frame.size.height = 45
                MBProgressHUD.hide(for: self.view, animated: true)
                self.refreshControl.endRefreshing()
            }
        });
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If the user is currently using the search bar pick the number of rows from
        // the filtered results. If not, pick the number of rows from the full list of movies.
        if searchInProgress {
            if let movies = filteredData {
                return movies.count
            }
        }
        else if let movies = movies {
            return movies.count
        }
        return 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Filter movies based on the title
        self.filteredData = searchText.isEmpty ? movies : self.movies?.filter({
            (result) -> Bool in
            let title = result["title"] as! String
            if title.range(of: searchText, options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil {
                return true
            } else {
                return false
            }
        })
        
        if searchText == "" {
            searchInProgress = false
        } else {
            searchInProgress = true
        }
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchInProgress = true;
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchInProgress = false;
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        var movie: NSDictionary!
        
        // If the user is currently using the search bar pick the movie from the filtered
        // results. If not, pick the movie from the full list of movies.
        if searchInProgress {
            movie = filteredData![indexPath.row]
        } else {
            movie = movies![indexPath.row]
        }
        
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = URL(string: baseUrl + posterPath)
            cell.posterView.setImageWith(imageUrl!)
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        // Use a white color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        
        cell.overviewLabel.sizeToFit()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        
        var movie: NSDictionary!
        
        // If the user is currently using the search bar pick the movie from the filtered
        // results. If not, pick the movie from the full list of movies.
        if searchInProgress {
            movie = filteredData![indexPath!.row]
        } else {
            movie = movies![indexPath!.row]
        }
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        if let posterPath = movie["poster_path"] as? String {
            detailViewController.imageUrl = "https://image.tmdb.org/t/p/w500" + posterPath
            detailViewController.smallImageUrl = "https://image.tmdb.org/t/p/w45" + posterPath
            detailViewController.largeImageUrl = "https://image.tmdb.org/t/p/original" + posterPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
