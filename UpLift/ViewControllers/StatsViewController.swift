//
//  StatsViewController.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/14/21.
//

import UIKit

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var muscleData: [Muscle : (Double, Int)] = [:]
    var muscleList: [Muscle] = []
    var total = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    
    func updateMuscleData() {
        //create muscleData and muscleList
        muscleList.removeAll()
        for muscle in Muscle.allCases {
            muscleList.append(muscle)
            muscleData[muscle] = (0.0, -1)
            
        }
        total = 0.0
        for workout in workouts {
            for exercise in workout.routines {
                for muscle in exercise.muscles {
                    let count = muscleData[muscle]?.0 ?? 0
                    muscleData[muscle]?.0 = count + 1
                    let muscleDate = muscleData[muscle]?.1 ?? 0
                    muscleData[muscle]?.1 = (muscleDate < workout.date && muscleDate != -1) ? muscleDate : workout.date
                }
                total += 1
            }
        }
        //sort data
        muscleList = muscleList.sorted( by: { muscleData[$0]!.0 > muscleData[$1]!.0 })
        
        if total == 0 {
            total = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateMuscleData()
        
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateMuscleData()
        refreshData()
    }
    
    func refreshData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "muscleCell") as! MuscleCell
        
        
        
        (cell.muscleStack.arrangedSubviews[0] as? UILabel)?.text = muscleList[indexPath.row].rawValue
        (cell.muscleStack.arrangedSubviews[1] as? UILabel)?.text = String("\(((muscleData[muscleList[indexPath.row]]!.0 / total) * 100).rounded())%")
        (cell.muscleStack.arrangedSubviews[2] as? UILabel)?.text = String("\((muscleData[muscleList[indexPath.row]]!.1 != -1) ? muscleData[muscleList[indexPath.row]]!.1 : 0) days ago")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Muscles"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
