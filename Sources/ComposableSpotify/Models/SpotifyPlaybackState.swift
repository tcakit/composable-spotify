//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation

public struct SpotifyPlayerState: Equatable {
    var track: AppRemoteTrack
    var isPaused: Bool
    var playerRestrictions: AppRemotePlaybackRestrictions
    var contextURI: URL
}
