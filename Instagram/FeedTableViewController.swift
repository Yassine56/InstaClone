//
//  FeedTableViewController.swift
//  
//
//  Created by Abouelouafa Yassine on 11/15/17.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    var imageFiles = [PFFile]()
    var userIds = [String]()
    var comments = [String]()
    var userInfos = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      let useridQuery = PFQuery(className: "Following")
        useridQuery.whereKey("follower", equalTo: PFUser.current()?.objectId!)
        useridQuery.findObjectsInBackground { (objects, error) in
            if (error != nil ) {
                print(error!)
                
            }else {
                if let users = objects {
                for user in users {
                    self.userIds.append(user["following"] as! String )
                }
                print(self.userIds)
                }
            }
            for user in self.userIds {
                print("expect comments")
                let postsQuery = PFQuery(className: "Post")
                postsQuery.whereKey("userId", equalTo: user)
                postsQuery.findObjectsInBackground(block: { (postsObjects, error) in
                    if error != nil {
                        print(error)
                        
                    }else  {
                        if let posts = postsObjects {
                            for post in posts {
                                self.comments.append(post["comment"] as! String)
                                self.userInfos.append(post["userInfo"] as! String)
                                self.imageFiles.append(post["imageFile"] as! PFFile)
                                self.tableView.reloadData()
                            }
                            print("comments")
                            print(self.comments)
                        }
                    }
                })
                
            }
        }
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! FeedTableViewCell

        
        cell.comment.text = comments[indexPath.row]
        cell.userinfo.text = userInfos[indexPath.row]
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            if let imagedata = data {
                let imagetodisplay = UIImage(data: imagedata)
                cell.postedImage.image = imagetodisplay
            }
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
