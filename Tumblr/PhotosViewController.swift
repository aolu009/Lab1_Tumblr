//
//  ViewController.swift
//  Tumblr
//
//  Created by Lu Ao on 10/9/16.
//  Copyright © 2016 Lu Ao. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var sourceDictionary : NSDictionary? = [:]
    
    @IBOutlet weak var photoTable: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        photoTable.rowHeight = 320
        photoTable.insertSubview(refreshControl, at: 0)
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //NSLog("response: \(responseDictionary)")
            
                    self.sourceDictionary = responseDictionary["response"] as? NSDictionary
                    //print("Testing:", self.sourceDictionary)
                    self.photoTable.reloadData()
                }
            }
        });
        task.resume()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var postArray : Array? = [AnyObject]()
        var postsDetailDictionary : NSDictionary? = [:]
        var photoArray : Array? = [AnyObject]()
        var photoDetailDictionary : NSDictionary? = [:]
        var photoSizeDictionary : NSDictionary? = [:]
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoViewCell") as! photoTableViewCell
        postArray = self.sourceDictionary?["posts"] as? Array
        postsDetailDictionary = postArray?[indexPath.row] as? NSDictionary
        photoArray = postsDetailDictionary?["photos"] as? Array
        photoDetailDictionary = photoArray?[0] as? NSDictionary
        photoSizeDictionary = photoDetailDictionary?["original_size"] as? NSDictionary
        
        if let imageUrl = photoSizeDictionary?["url"] as? String{
            print("imageUrl:",imageUrl)
            cell.photoview.setImageWith(URL(string:imageUrl)!)
        }
        cell.accessoryType = UITableViewCellAccessoryType(rawValue: 0)!
         return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var postArray : Array? = [AnyObject]()
        postArray = self.sourceDictionary?["posts"] as? Array
        if let postcount  = postArray?.endIndex{
            return postcount
            
        }
        else{
            return 10000
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )

        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //NSLog("response: \(responseDictionary)")
                    
                    self.sourceDictionary = responseDictionary["response"] as? NSDictionary
                    //print("Testing:", self.sourceDictionary)
                    // Reload the tableView now that there is new data
                    self.photoTable.reloadData()
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
            }
        });
        task.resume()
    }
    
    //Finding and passing the correct segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! photoDetailsViewController
            let indexPath = photoTable.indexPath(for: sender as! photoTableViewCell)
            let selectedCell = photoTable.cellForRow(at: indexPath!) as! photoTableViewCell
            destinationVC.image = selectedCell.photoview.image
    }
    
}

