//
//  Routine.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/8/21.
//

import Foundation

class Routine {
    var name = ""
    var exercises: [Exercise] = []
    var reps: [Int] = []
    
    init() {}
    
    init(name: String, routine: [Exercise], amount:[Int]) {
        self.name = name
        self.reps = amount
        self.exercises = routine
    }
}
