//
//  WorkoutViewController.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/11/21.
//

import UIKit

class WorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutNameLabel: UITextField!
    var workout: Workout = Workout()
    
    var edittingWorkout: Bool = false
    var editIndex = 0
    var isFromRoutine: Bool = false
    var isFromWorkout: Bool = false
    var mainDelegate: ViewController?
    var pastDelegate: HistoryViewController?
    
    @IBAction func saveWorkout(_ sender: Any) {
        tableView.visibleCells.forEach { cell in
            var count = 0
            (cell as? WorkoutCell)?.exerciseStack.arrangedSubviews.forEach { sub in
                if let stack = sub as? UIStackView {
                    stack.arrangedSubviews[1].resignFirstResponder()
                    stack.arrangedSubviews[4].resignFirstResponder()
                    //set data
                    workout.weights[tableView.indexPath(for: cell)!.row][count] = Double((stack.arrangedSubviews[1] as? UITextField)?.text ?? "0.0") ?? 0.0
                    
                    //also set prev and best weight on exercise
                    let exercise = workout.routines[tableView.indexPath(for: cell)!.row]
                    let weight = workout.weights[tableView.indexPath(for: cell)!.row][count]
                    exercise.best = max(exercise.best, weight)
                    exercise.previous = weight
                    (cell as? WorkoutCell)?.nameLabel.text = exercise.name
                    
                    workout.reps[tableView.indexPath(for: cell)!.row][count] = Int((stack.arrangedSubviews[4] as? UITextField)?.text ?? "0") ?? 0
                    workout.done[tableView.indexPath(for: cell)!.row][count] = (stack.arrangedSubviews[5] as? UIButton)?.isSelected ?? false
                }
                count += 1
            }
            count += 1
        }
        workout.name = workoutNameLabel.text ?? "New Workout"
        workoutNameLabel.resignFirstResponder()
        
        if edittingWorkout {
            workouts[editIndex] = workout
        } else {
            workouts.append(workout)
        }
        self.mainDelegate?.refreshData()
        self.pastDelegate?.refreshData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissFirstResponders(_ sender: UIControl) {
        dismissKeyboards()
    }
    
    func dismissKeyboards() {
        tableView.visibleCells.forEach { cell in
            var count = 0
            (cell as? WorkoutCell)?.exerciseStack.arrangedSubviews.forEach { sub in
                if let stack = sub as? UIStackView {
                    stack.arrangedSubviews[1].resignFirstResponder()
                    stack.arrangedSubviews[4].resignFirstResponder()
                    //set data
                    workout.weights[tableView.indexPath(for: cell)!.row][count] = Double((stack.arrangedSubviews[1] as? UITextField)?.text ?? "0.0") ?? 0.0
                    workout.reps[tableView.indexPath(for: cell)!.row][count] = Int((stack.arrangedSubviews[4] as? UITextField)?.text ?? "0") ?? 0
                    workout.done[tableView.indexPath(for: cell)!.row][count] = (stack.arrangedSubviews[5] as? UIButton)?.isSelected ?? false
                }
                count += 1
            }
            count += 1
        }
        workout.name = workoutNameLabel.text ?? "New Workout"
        workoutNameLabel.resignFirstResponder()
    }
    
    func routineToWorkout(routine: Routine) {
        var setAndRep: [[Int]] = [[]]
        var weights: [[Double]] = [[]]
        var done: [[Bool]] = [[]]
        for i in 0..<routine.reps.count {
            setAndRep.append([Int](repeating: 0, count: routine.reps[i]))
            weights.append([Double](repeating: 0.0, count: routine.reps[i]))
            done.append([Bool](repeating: false, count: routine.reps[i]))
        }
        setAndRep.remove(at: 0)
        weights.remove(at: 0)
        done.remove(at: 0)
        let newWorkout = Workout(name: routine.name, exercise: routine.exercises, reps: setAndRep, weights: weights, done: done)
        workout = newWorkout
    }
    
    func prepareWorkout(newWorkout: Workout) {
        //coming from edit or start based on workout
        if edittingWorkout {
            self.workout = newWorkout
        } else {
            var done: [[Bool]] = [[]]
            for i in 0..<newWorkout.reps.count {
                done.append([Bool](repeating: false, count: newWorkout.reps[i].count))
            }
            done.remove(at: 0)
            self.workout = Workout(name: newWorkout.name, exercise: newWorkout.routines, reps: newWorkout.reps, weights: newWorkout.weights, done: done)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        workoutNameLabel.text = workout.name
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissFirstResponders))
        tableView.addGestureRecognizer(gesture)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workout.routines.count != 0) ? workout.routines.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "workoutCell") as! WorkoutCell
        cell.delegate = self
        
        //add stacks as needed
        createStackViewForCell(cell: cell, index: indexPath)
        cell.nameLabel.text = workout.routines[indexPath.row].name
        
        return cell
    }
    
    func createRow(index: IndexPath, i: Int) -> UIStackView {
        let setStack = UIStackView()
        setStack.axis = .horizontal
        setStack.distribution = .fillEqually
        setStack.alignment = .center
        setStack.spacing = 15
        
        let bullet = UILabel()
        bullet.text = String(i + 1)
        
        let weight = UITextField()
        weight.placeholder = String(workout.routines[index.row].previous)
        weight.borderStyle = .line
        weight.text = (!workout.weights[index.row].isEmpty) ? String(workout.weights[index.row][i]) : ""
        weight.keyboardType = .default
        
        let unit = UILabel()
        unit.text = "lbs"
        
        let by = UILabel()
        by.text = "x"
        
        let reps = UITextField()
        reps.placeholder = String(workout.reps[index.row][i])
        reps.borderStyle = .line
        reps.text = (!workout.reps[index.row].isEmpty) ? String(workout.reps[index.row][i]) : ""
        reps.keyboardType = .default
        
        let done = UIButton()
        done.setImage(UIImage(named: "checked"), for: .selected)
        done.setImage(UIImage(named: "unchecked"), for: .normal)
        done.isSelected = workout.done[index.row][i]
        done.addTarget(self, action: #selector(checkBox(sender:)), for: .touchUpInside)
        
        setStack.addArrangedSubview(bullet)
        setStack.addArrangedSubview(weight)
        setStack.addArrangedSubview(unit)
        setStack.addArrangedSubview(by)
        setStack.addArrangedSubview(reps)
        setStack.addArrangedSubview(done)
        
        return setStack
    }
    
    @objc func checkBox(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
  
    func createStackViewForCell(cell: WorkoutCell, index: IndexPath) {
        //create horizontal stack
        //add to vertical stack
        cell.exerciseStack.arrangedSubviews.forEach { sub in
            sub.removeFromSuperview()
        }
        for i in 0..<workout.reps[index.row].count {
            cell.exerciseStack.addArrangedSubview(createRow(index: index, i: i))
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (workout.name != "") ? workout.name : "New Workout"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //get number of sets at indexpath.row
        return 25.0 + CGFloat(workout.reps[indexPath.row].count) * 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //change newRoutine exercise
        let exercise = workout.routines.remove(at: sourceIndexPath.row)
        workout.routines.insert(exercise, at: destinationIndexPath.row)
        
        //reps
        let rep = workout.reps.remove(at: sourceIndexPath.row)
        workout.reps.insert(rep, at: destinationIndexPath.row)
        
        //weights
        let weights = workout.weights.remove(at: sourceIndexPath.row)
        workout.weights.insert(weights, at: destinationIndexPath.row)
        
        let done = workout.done.remove(at: sourceIndexPath.row)
        workout.done.insert(done, at: destinationIndexPath.row)
    }

}

extension WorkoutViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension WorkoutViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}
