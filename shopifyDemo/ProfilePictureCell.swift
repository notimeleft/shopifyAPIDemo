//
//  ProfilePictureCell.swift
//  shopifyDemo
//
//  Created by Jerry Wang on 3/23/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

//custom profile cell: contains a profile picture and a description label
class ProfilePictureCell: UITableViewCell {
    @IBOutlet weak var profilePictureView: UIImageView!
    //the label will either grow or shrink depending on its contents. It's got a higher content hugging/content compression resistance priority than the profilePicture. 
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //initialization actions here
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Zev comment: How auto sizing cells work:
    // table view will ask each cell:
    // cell.systemLayoutFitting(
    //      CGSize(width: tableView.width, height: 0),
    //      horizontalFittingPriority: 1000,
    //      verticalFittingPriority: 50)
    //
    // In other words: "How big would you be if you tried to fit in a space
    // that is <table view width> wide and 0 high. You MUST be the same
    // width as the table view, and I barely care at all that you are 0 high.
//    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
//    }

}


