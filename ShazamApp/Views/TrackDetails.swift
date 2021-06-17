//
//  TrackDetails.swift
//  ShazamApp
//
//  Created by Umayanga Alahakoon on 6/17/21.
//

import SwiftUI

struct TrackDetails: View {
    @ObservedObject var shazamSession: ShazamRecognizer
    var track: Track
    
    var body: some View {
        VStack {
            AsyncImage(url: track.artwork) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    Color.gray
                        .aspectRatio(1, contentMode: .fill)
                        .scaledToFit()
                        .overlay(
                            Image(systemName:  "music.note")
                                .font(.system(size: 80))
                        )
                    
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            if let title = track.title {
                Text(title)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
            }
            
            if let artist = track.artist {
                Text(artist)
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            
            if let appleMusicURL = track.appleMusicURL {
                Link(destination: appleMusicURL) {
                    Text("Play in Apple Music")
                }
                .buttonStyle(.bordered)
                .tint(.pink)
            }
        }
    }
}
