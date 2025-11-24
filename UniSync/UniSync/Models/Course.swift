//
//  Course.swift
//  UniSync
//
//  Created by Ahmad Hassan on 2025-11-24.
//

import Foundation

struct Course: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var code: String
    var name: String
    var professor: String
    var schedule: String
    var location: String
    var color: String // HEX like "#3B82F6"
}
