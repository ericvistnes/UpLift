//
//  RoutineViewController.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/11/21.
//

import UIKit

class RoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var newRoutine = Routine(name: "", routine: [Exercise()], amount: [0])
    @IBOutlet weak var routineNameLabel: UITextField!
    
    var isEditRoutine = false
    var editIndex = 0
    var delegate: ViewController!
    
    @IBAction func dismissFirstResponders(_ sender: UIControl) {
        var count = 0
        tableView.visibleCells.forEach { cell in
            (cell as? CreateRoutineCell)?.exerciseStack.arrangedSubviews[2].resignFirstResponder()
            //set the two values to the corresponding newRoutine() data
            newRoutine.exercises[count] = exercises.first(where:  {$0.name == ((cell as? CreateRoutineCell)?.exerciseStack.arrangedSubviews[2] as? UITextField)?.text }) ?? Exercise()
            newRoutine.reps[count] = Int((((cell as? CreateRoutineCell)?.exerciseStack.arrangedSubviews[0] as? UITextField)?.text)!) ?? 0
            count += 1
        }
        newRoutine.name = routineNameLabel.text ?? "New Routine"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData() {
        tableView.reloadData()
    }
    
    @IBAction func addExercise(_ sender: Any) {
        //add to routine
        //relayout tableview to include it
        newRoutine.exercises.append(Exercise())
        newRoutine.reps.append(0)
        tableView.reloadData()
    }
    
    @IBAction func save(_ sender: Any) {
        //popup alert if an exercise is not fully populated
        
        if isEditRoutine {
            routines[editIndex] = newRoutine
        } else {
            routines.append(newRoutine)
        }
        //initial viewcontroller needs to refresh
        self.delegate.refreshData()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissFirstResponders))
        tableView.addGestureRecognizer(gesture)
        
        routineNameLabel.text = newRoutine.name
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (newRoutine.exercises.count != 0) ? newRoutine.exercises.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (newRoutine.name != "") ? newRoutine.name : "New Routine"
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //change newRoutine exercise
        let exercise = newRoutine.exercises.remove(at: sourceIndexPath.row)
        newRoutine.exercises.insert(exercise, at: destinationIndexPath.row)
        
        //reps
        let rep = newRoutine.reps.remove(at: sourceIndexPath.row)
        newRoutine.reps.insert(rep, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "createRoutine") as! CreateRoutineCell
        cell.delegate = self
        
        
        if newRoutine.reps.count < indexPath.row + 1 {
            cell.nameLabel.text = "Exercise"
            (cell.exerciseStack.arrangedSubviews[0] as! UITextField).text = "3"
            (cell.exerciseStack.arrangedSubviews[2] as! UITextField).text = "Bench Press"
        } else {
            cell.nameLabel.text = (newRoutine.exercises[indexPath.row].name != "") ? newRoutine.exercises[indexPath.row].name : "Exercise"
            (cell.exerciseStack.arrangedSubviews[0] as! UITextField).text = String(newRoutine.reps[indexPath.row])
            (cell.exerciseStack.arrangedSubviews[2] as! UITextField).text = newRoutine.exercises[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension RoutineViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension RoutineViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}
