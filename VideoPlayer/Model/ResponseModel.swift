//
//  ResponseModel.swift
//  VideoPlayer
//
//  Created by Sai Balaji on 11/07/24.
//

import Foundation

struct Movie: Codable {
    let description, id: String?
    let thumb: String?
    let title: String?
    let url: String?
}


