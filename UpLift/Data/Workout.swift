//
//  Workout.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/8/21.
//

import Foundation

class Workout {
    var name = ""
    var routines: [Exercise] = []
    var reps: [[Int]] = [[]]
    var weights: [[Double]] = [[]]
    var done: [[Bool]] = [[]]
    var date: Int = 0
    
    init(name: String, exercise: [Exercise], reps: [[Int]], weights: [[Double]], done: [[Bool]], date: Int = 0) {
        self.name = name
        self.routines = exercise
        self.reps = reps
        self.weights = weights
        self.done = done
        self.date = date
    }
    
    init() {}
    
    func addRemoveRep() {
        
    }
    
    func addRemoveExercise() {
        
    }
}
