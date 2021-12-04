//
//  HistoryViewController.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/14/21.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex: IndexPath!
    var editPressed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func editPressed(cell: PastWorkoutCell) {
        //send delegates with data
        //create segues
        editPressed = true
        selectedIndex = self.tableView.indexPath(for: cell)!
        performSegue(withIdentifier: "pastWorkoutSegue", sender: self)
    }
    
    func refreshData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if indexPath.section == 0 {
                workouts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            } else {
                routines.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "pastWorkouts") as! PastWorkoutCell
        cell.delegate = self
        
        //add stacks as needed
        createStackViewForCell(cell: cell, index: indexPath)
        cell.nameLabel.text = workouts[indexPath.row].name
        cell.totalLabel.text = String((workouts[indexPath.row].weights.reduce([], +)).reduce(0.0, +)) + " lbs total"
        
        return cell
    }
    
    func createStackViewForCell(cell: PastWorkoutCell, index: IndexPath) {
        //create horizontal stack
        //add to vertical stack
        cell.exerciseStack.arrangedSubviews.forEach { sub in
            sub.removeFromSuperview()
        }
        for i in 0..<workouts[index.row].routines.count {
            cell.exerciseStack.addArrangedSubview(createRow(index: index, i: i))
        }
    }
    
    func createRow(index: IndexPath, i: Int) -> UIStackView {
        let setStack = UIStackView()
        setStack.axis = .horizontal
        setStack.distribution = .fillProportionally
        setStack.alignment = .center
        setStack.spacing = 10
        
        let sets = UILabel()
        sets.text = "\(workouts[index.row].reps[i].count)x \(workouts[index.row].routines[i].name)"
        sets.font = sets.font.withSize(14)
        
        let repAndWeight = UILabel()
        repAndWeight.text = "\(workouts[index.row].weights[i].last ?? 0.0)lbs x  \(workouts[index.row].reps[i].last ?? 1)"
        repAndWeight.font = repAndWeight.font.withSize(14)
        
        let muscles = UILabel()
        muscles.text = workouts[index.row].routines[i].muscles[0].rawValue
        muscles.lineBreakMode = .byTruncatingTail
        muscles.font = muscles.font.withSize(14)
        
        setStack.addArrangedSubview(sets)
        setStack.addArrangedSubview(repAndWeight)
        setStack.addArrangedSubview(muscles)
        
        return setStack
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //get number of sets at indexpath.row
        return 40.0 + CGFloat(workouts[indexPath.row].reps.count) * 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set data from workout in prepareForSegue
        selectedIndex = indexPath
        performSegue(withIdentifier: "pastWorkoutSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let workoutCon = segue.destination as? WorkoutViewController {
            if editPressed {
                workoutCon.edittingWorkout = true
            }
            workoutCon.prepareWorkout(newWorkout: workouts[selectedIndex.row])
            workoutCon.pastDelegate = self
            workoutCon.editIndex = selectedIndex.row
            
            editPressed = false
        }
    }
    
}
