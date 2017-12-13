//
//  UserTableViewController.swift
//  Instagram
//
//  Created by Abouelouafa Yassine on 11/14/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit
import Parse
class UserTableViewController: UITableViewController {
    
    var usernames = [String]()
    var objectIds = [String]()
    var isFollowing = ["" : true]
    var refresh = UIRefreshControl()
    
   @objc func updateTableview() {
        isFollowing.removeAll()
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        query?.findObjectsInBackground { (users, error) in
            if error != nil {
                print(error!)
            }else {
                if let userts = users {
                    for object in userts {
                        
                        if let user = object as? PFUser  {
                            let userarray = user.username?.split(separator: "@")
                            self.usernames.append(String(userarray![0]))
                            
                            self.objectIds.append(user.objectId!)
                            
                            let query = PFQuery(className: "Following")
                            query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                            query.whereKey("following", equalTo: user.objectId)
                            query.findObjectsInBackground(block: { (objects, error) in
                                if error != nil {
                                    print(error)
                                }else {
                                    if let followings = objects as [PFObject]! {
                                        if followings.count > 0 {
                                            self.isFollowing[user.objectId! ] = true
                                        }else {
                                            self.isFollowing[user.objectId! ] = false
                                        }
                                        if self.isFollowing.count == self.usernames.count {
                                        self.tableView.reloadData()
                                        
                                        self.refresh.endRefreshing()
                                        }
                                    }
                                }
                            })
                        }
                        
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logOutId", sender: self)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let followboolean = isFollowing[objectIds[indexPath.row]] {
            if followboolean {
                isFollowing[objectIds[indexPath.row]] = false
                cell?.accessoryType = UITableViewCellAccessoryType.none
                let query = PFQuery(className: "Following")
                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
                query.whereKey("following", equalTo: objectIds[indexPath.row])
                query.findObjectsInBackground(block: { (objects, error) in
                    if error != nil {
                        print(error)
                    }else {
                        if let objects = objects {
                            for object in objects {
                                object.deleteInBackground()
                            }
                        }
                        
                    }
                })
                
            }else {
                isFollowing[objectIds[indexPath.row]] = true
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                let following = PFObject(className: "Following")
                following["follower"] = PFUser.current()?.objectId
                following["following"] =  objectIds[indexPath.row]
                following.saveInBackground()
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTableview()
        refresh.attributedTitle = NSAttributedString(string: "pull to refresh")
        refresh.addTarget(self, action: #selector(updateTableview), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh)
        
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
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
         
        cell.textLabel?.text = usernames[indexPath.row]
        if let followsBoolean = isFollowing[objectIds[indexPath.row]]{
                    if followsBoolean {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
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
