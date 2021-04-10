//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation

public struct AppRemotePlaybackRestrictions: Equatable {
    public var canSkipNext: Bool
    public var canSkipPrevious: Bool
    public var canRepeatTrack: Bool
    public var canRepeatContext: Bool
    public var canToggleShuffle: Bool
    public var canSeek: Bool
}
