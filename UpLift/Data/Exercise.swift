//
//  Exercise.swift
//  UpLift
//
//  Created by Eric Vistnes on 3/8/21.
//

import Foundation

enum Muscle: String, CaseIterable {
    case chest
    case abs
    case glutes
    case biceps
    case triceps
    case shoulders
    case back
    case hamstrings
    case quads
    case calves
}

class Exercise {
    var name = ""
    var muscles: [Muscle] = []
    var best: Double = 0.0
    var previous: Double = 0.0
    
    init() {}
    
    init(name: String, muscles: [Muscle]) {
        self.name = name
        self.muscles = muscles
    }
}
