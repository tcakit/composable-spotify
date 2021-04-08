//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

import Foundation
import SpotifyiOS

public struct AppRemoteTrack: Equatable {
    let remoteTrack: SPTAppRemoteTrack?

    public init(_ remoteTrack: SPTAppRemoteTrack?) {
        self.remoteTrack = remoteTrack as SPTAppRemoteTrack?
    }

    public static func == (lhs: AppRemoteTrack, rhs: AppRemoteTrack) -> Bool {
        lhs.remoteTrack?.name == rhs.remoteTrack?.name &&
            lhs.remoteTrack?.uri == rhs.remoteTrack?.uri &&
            lhs.remoteTrack?.duration == rhs.remoteTrack?.duration &&
            lhs.remoteTrack?.artist.name == rhs.remoteTrack?.artist.name &&
            lhs.remoteTrack?.artist.uri == rhs.remoteTrack?.artist.uri &&
            lhs.remoteTrack?.album.name == rhs.remoteTrack?.album.name &&
            lhs.remoteTrack?.album.uri == rhs.remoteTrack?.album.uri &&
            lhs.remoteTrack?.isSaved == rhs.remoteTrack?.isSaved &&
            lhs.remoteTrack?.isEpisode == rhs.remoteTrack?.isEpisode &&
            lhs.remoteTrack?.isPodcast == rhs.remoteTrack?.isPodcast
    }
}
