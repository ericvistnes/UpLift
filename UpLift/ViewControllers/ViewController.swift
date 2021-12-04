//
//  ViewController.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/3/21.
//

import UIKit

let exercises = [Exercise(name: "Bench Press", muscles: [.chest]), Exercise(name: "Chest Fly", muscles: [.chest]), Exercise(name: "Lat Pulldown", muscles: [.back, .abs]), Exercise(name: "Pull-Up", muscles: [.back]), Exercise(name: "Bicep Curl", muscles: [.biceps]), Exercise(name: "Hammer Curl", muscles: [.biceps, .triceps]), Exercise(name: "Tricep Pulldown", muscles: [.triceps]), Exercise(name: "Shoulder Press", muscles: [.shoulders]), Exercise(name: "Lateral Raise", muscles: [.shoulders]), Exercise(name: "Squat", muscles: [.hamstrings, .quads, .glutes, .calves]), Exercise(name: "Deadlift", muscles: [.back, .hamstrings, .quads, .glutes]), Exercise(name: "Calves Press", muscles: [.calves]), Exercise(name: "Sit Up", muscles: [.abs])]

var workouts: [Workout] = [Workout(name: "Upper Body 1", exercise: [Exercise(name: "Bench Press", muscles: [.chest]), Exercise(name: "Shoulder Press", muscles: [.shoulders])], reps: [[12, 12, 12], [8, 8, 8]], weights: [[150, 160, 175], [20, 20, 25]], done: [[true, true, true], [true, true, true]], date: 5)]
var routines: [Routine] = [Routine(name: "Upper Body", routine: [exercises[0], exercises[2], exercises[3]], amount: [4, 4, 5]), Routine(name: "Lower Body", routine: [exercises[1], exercises[4], exercises[5]], amount: [2, 4, 5])]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex: IndexPath = IndexPath()
    var createRoutine: Bool = false
    var buttonTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    @objc func createRoutineTapped() {
        createRoutine = true
        performSegue(withIdentifier: "routineSegue", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func editTapped(cell: RoutineCell) {
        //segue to Workout ViewController with data
        selectedIndex = self.tableView.indexPath(for: cell)!
        buttonTapped = true
        performSegue(withIdentifier: "workoutSegue", sender: self)
    }
    
    func refreshData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return workouts.count}
        else { return routines.count }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createRoutineTapped))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "routine") as! RoutineCell
        
        let header = self.tableView.headerView(forSection: 1)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createRoutineTapped))
        header?.contentView.addGestureRecognizer(tapGesture)
        
        cell.delegate = self
        if indexPath.section == 0 {
            let data = workouts[indexPath.row]
            cell.name?.text = data.name
            cell.editButton.setTitle("Edit", for: .normal)
            var i = 0
            cell.list?.subviews.forEach { sub in
                if let exercise = sub as? UILabel {
                    if i < data.reps.count {
                        exercise.text = "\(data.reps[i].count)x \(data.routines[i].name) @\(Int(data.weights[i].last ?? 0))"
                        i += 1
                    } else {
                        exercise.removeFromSuperview()
                    }
                }
            }
        } else {
            let data = routines[indexPath.row]
            cell.name?.text = data.name
            cell.editButton.setTitle("Start", for: .normal)
            var i = 0
            cell.list?.subviews.forEach { sub in
                if let exercise = sub as? UILabel {
                    if i < data.reps.count {
                        exercise.text = "\(data.reps[i])x \(data.exercises[i].name)"
                        i += 1
                    } else {
                        exercise.removeFromSuperview()
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //set data from workout in prepareForSegue
            selectedIndex = indexPath
            performSegue(withIdentifier: "workoutSegue", sender: self)
        } else {
            //set data from Routine in prepareForSegue
            selectedIndex = indexPath
            performSegue(withIdentifier: "routineSegue", sender: self)
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 20.0 + CGFloat(workouts[indexPath.row].reps.count) * 35.0
        } else {
            return 20.0 + CGFloat(routines[indexPath.row].reps.count) * 35.0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Workouts"
            //remove touch on this so you can only start workouts that have routines?
        } else {
            return "Create Routine  ➕"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //use selectedIndex to get data to send to the destination
        if !createRoutine {
            if selectedIndex.section == 0 {
                //set isEditingWorkout or not
                //call prepareWorkout with data
                if let createViewController = segue.destination as? WorkoutViewController {
                    createViewController.edittingWorkout = buttonTapped
                    createViewController.prepareWorkout(newWorkout: workouts[selectedIndex.row])
                    createViewController.mainDelegate = self
                    createViewController.editIndex = selectedIndex.row
                }
                buttonTapped = false
            } else {
                //check if edit button or index selected based on dest
                if let createViewController = segue.destination as? WorkoutViewController {
                    createViewController.routineToWorkout(routine: routines[selectedIndex.row])
                    buttonTapped = false
                    createViewController.editIndex = selectedIndex.row
                    createViewController.mainDelegate = self
                } else if let createViewController = segue.destination as? RoutineViewController {
                    createViewController.editIndex = selectedIndex.row
                    createViewController.isEditRoutine = true
                    createViewController.newRoutine = routines[selectedIndex.row]
                    createViewController.delegate = self
                }
            }
        } else {
            if let createViewController = segue.destination as? RoutineViewController {
                createViewController.delegate = self
            }
        }
        createRoutine = false
    }
}

