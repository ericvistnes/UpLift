//
//  WorkoutCell.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/8/21.
//

import UIKit

class WorkoutCell: UITableViewCell {

    @IBOutlet weak var exerciseStack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    var delegate: WorkoutViewController?
    
    @IBAction func deleteExercise(_ sender: Any) {
        let index = self.delegate?.tableView.indexPath(for: self)?.row ?? 0
        self.delegate?.workout.routines.remove(at: index)
        self.delegate?.workout.reps.remove(at: index)
        self.delegate?.workout.done.remove(at: index)
        self.delegate?.workout.weights.remove(at: index)
        delegate!.tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        exerciseStack.axis = .vertical
        exerciseStack.distribution = .equalSpacing
        exerciseStack.alignment = .center
        exerciseStack.spacing = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
