 //
//  FeedTableViewCell.swift
//  Instagram
//
//  Created by Abouelouafa Yassine on 11/15/17.
//  Copyright © 2017 Abouelouafa Yassine. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {


    @IBOutlet var userinfo: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var postedImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
