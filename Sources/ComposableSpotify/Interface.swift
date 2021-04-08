//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

#if canImport(MediaPlayer) && os(iOS)

import Combine
import ComposableArchitecture
import Foundation
import MediaPlayer
import SpotifyiOS

public struct SpotifyManager {
    public enum Action: Equatable {
        case didConnect
        case didDisconnect(Error)
        case didFailConnection(Error)
        case playerChangedState(SpotifyPlayerState)
        case fetchedImage(UIImage?)
        case authorizationResult(Result<String, Error>)
    }
    
    public var connectionStatus: (AnyHashable) -> ConnectionStatus = { _ in _unimplemented("connectionStatus") }

    var create: (AnyHashable, SPTConfiguration, String?) -> Effect<Action, Never> = { _, _, _ in _unimplemented("create") }
    var destroy: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("destroy") }
    var handleAuthorization: (AnyHashable, URL) -> Effect<Never, Never> = { _, _ in _unimplemented("handleAuthorization") }
    var authorizeSpotifyAndPlay: (AnyHashable, String) -> Effect<Never, Never> = { _, _ in _unimplemented("authorizeSpotifyAndPlay") }
    var connect: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("connect") }
    var disconnect: (AnyHashable) -> Effect<Never, Never> = { _ in _unimplemented("disconnect") }
    var subscribe: (AnyHashable, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _ in _unimplemented("subscribe") }
    var unsubscribe: (AnyHashable, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _ in _unimplemented("unsubscribe") }
    var getPlayerState: (AnyHashable, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _ in _unimplemented("getPlayerState") }
    var play: (AnyHashable, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _ in _unimplemented("play") }
    var pause: (AnyHashable, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _ in _unimplemented("pause") }
    var skipForward: (AnyHashable, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _ in _unimplemented("skipForward") }
    var skipBackward: (AnyHashable, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _ in _unimplemented("skipBackward") }
    var fetchImage: (AnyHashable, SPTAppRemoteTrack, SPTAppRemoteCallback?) -> Effect<Never, Never> = { _, _, _ in _unimplemented("fetchImage") }
    var setVolume: (AnyHashable, Float) -> Effect<Never, Never> = { _, _ in _unimplemented("setVolume") }

    public struct Error: Swift.Error, Equatable {
        public let error: NSError?

        public init(_ error: Swift.Error?) {
            self.error = error as NSError?
        }
    }

    public func create(id: AnyHashable, configuration: SPTConfiguration, accessToken: String?) -> Effect<Action, Never> {
        create(id, configuration, accessToken)
    }

    public func destroy(id: AnyHashable) -> Effect<Never, Never> {
        destroy(id)
    }

    public func handleAuthorization(id: AnyHashable, url: URL) -> Effect<Never, Never> {
        handleAuthorization(id, url)
    }

    public func authorizeSpotifyAndPlay(id: AnyHashable, uri: String) -> Effect<Never, Never> {
        authorizeSpotifyAndPlay(id, uri)
    }

    public func connect(id: AnyHashable) -> Effect<Never, Never> {
        connect(id)
    }

    public func disconnect(id: AnyHashable) -> Effect<Never, Never> {
        disconnect(id)
    }

    public func subscribe(id: AnyHashable, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        subscribe(id, completion)
    }

    public func unsubscribe(id: AnyHashable, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        unsubscribe(id, completion)
    }

    public func getPlayerState(id: AnyHashable, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        getPlayerState(id, completion)
    }

    public func play(id: AnyHashable, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        play(id, completion)
    }

    public func pause(id: AnyHashable, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        pause(id, completion)
    }

    public func skipForward(id: AnyHashable, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        skipForward(id, completion)
    }

    public func skipBackward(id: AnyHashable, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        skipBackward(id, completion)
    }

    public func fetchImage(id: AnyHashable, track: SPTAppRemoteTrack, completion: SPTAppRemoteCallback?) -> Effect<Never, Never> {
        fetchImage(id, track, completion)
    }

    public func setVolume(id: AnyHashable, level: Float) -> Effect<Never, Never> {
        setVolume(id, level)
    }
}


#endif
