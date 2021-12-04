//
//  CreateRoutineCell.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/11/21.
//

import UIKit

class CreateRoutineCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return exercises.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        (exerciseStack.arrangedSubviews[2] as? UITextField)!.text = pickerData[row]
    }

    var pickerData: [String] = []
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var exerciseStack: UIStackView!
    var delegate: RoutineViewController?
    
    @IBAction func deleteExercise(_ sender: Any) {
        //remove from routines data
        let index = self.delegate?.tableView.indexPath(for: self)?.row ?? 0
        self.delegate?.newRoutine.exercises.remove(at: index)
        self.delegate?.newRoutine.reps.remove(at: index)
        delegate!.tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let thePicker = UIPickerView()
        (exerciseStack.arrangedSubviews[2] as? UITextField)!.inputView = thePicker
        exercises.forEach { exercise in
            pickerData.append(exercise.name)
        }
        (exerciseStack.arrangedSubviews[0] as? UITextField)!.keyboardType =  .numberPad
        thePicker.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
