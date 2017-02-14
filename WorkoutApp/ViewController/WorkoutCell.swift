//
//  WorkoutCell.swift
//  WorkoutApp
//
//  Created by joshua on 2/9/17.
//  Copyright © 2017 joshua. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {

    
    @IBOutlet weak var workoutID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
