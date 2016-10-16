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
        photoTable.rowHeight = 320
        let refreshControl = UIRefreshControl()
        print("Hello World Here")
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
        //var imageUrl : String? = " "
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoViewCell") as! photoTableViewCell
        //cell.photoview.conte
        postArray = self.sourceDictionary?["posts"] as? Array
         //print("Testing:", postArray?[0])
        postsDetailDictionary = postArray?[indexPath.row] as? NSDictionary
         //print("Testing:", postsDetailDictionary)
        photoArray = postsDetailDictionary?["photos"] as? Array
         //print("Testing:", photoArray?[0])
        photoDetailDictionary = photoArray?[0] as? NSDictionary
         //print("Testing:", photoDetailDictionary?["original_size"])
        photoSizeDictionary = photoDetailDictionary?["original_size"] as? NSDictionary
        print("Testing:", photoSizeDictionary?["url"])
        
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
        return 10000
        
    }
    //Finding and passing the correct segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            let destinationVC = segue.destination as! photoDetailsViewController
            let indexPath = photoTable.indexPath(for: sender as! photoTableViewCell)
            print("Selected Index:",indexPath)
            let selectedCell = photoTable.cellForRow(at: indexPath!) as! photoTableViewCell
            destinationVC.image = selectedCell.photoview.image
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)

    }
}

