//
//  PastWorkoutCell.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/14/21.
//

import UIKit

class PastWorkoutCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var exerciseStack: UIStackView!
    var delegate: HistoryViewController!
    
    @IBAction func editPressed(_ sender: Any) {
        self.delegate.editPressed(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
