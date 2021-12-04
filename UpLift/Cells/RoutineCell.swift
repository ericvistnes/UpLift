//
//  RoutineCell.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/8/21.
//

import UIKit

class RoutineCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var list: UIStackView!
    var delegate: ViewController?
    @IBOutlet weak var editButton: UIButton!
    
    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.editTapped(cell: self)
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
