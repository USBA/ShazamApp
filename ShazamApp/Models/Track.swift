//
//  Track.swift
//  ShazamApp
//
//  Created by Umayanga Alahakoon on 6/16/21.
//

import SwiftUI

struct Track: Identifiable {
    var id = UUID().uuidString
    var title: String?
    var artist: String?
    var artwork: URL?
    var genres: [String]
    var appleMusicURL: URL?
}
