//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation

public struct AppRemotePlaybackRestrictions: Equatable {
    var canSkipNext: Bool
    var canSkipPrevious: Bool
    var canRepeatTrack: Bool
    var canRepeatContext: Bool
    var canToggleShuffle: Bool
    var canSeek: Bool
}
