//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation

public struct SpotifyPlayerState: Equatable {
    public var track: AppRemoteTrack
    public var isPaused: Bool
    public var playerRestrictions: AppRemotePlaybackRestrictions
    public var contextURI: URL
}
