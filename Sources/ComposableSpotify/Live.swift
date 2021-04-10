//
//  File.swift
//  
//
//  Created by Joe Blau on 4/7/21.
//

#if canImport(MediaPlayer)
import MediaPlayer
#endif

import Combine
import ComposableArchitecture
import Foundation
import SpotifyiOS

enum SpotifyError: Error {
    case error(String)
}

public extension SpotifyManager {
    static let live: SpotifyManager = { () -> SpotifyManager in
        var manager = SpotifyManager()
        
        manager.connectionStatus = { id in return dependencies[id]?.connectionStatus ?? .unknown }
        
        manager.create = { id, configuration, accessToken in
            Effect.run { subscriber in
                let connectionStatus: ConnectionStatus
                switch accessToken {
                case let .some(accessToken):
                    connectionStatus = .connected
                    UserDefaults.standard.set(connectionStatus.rawValue, forKey: "\(SpotifyManager.self)_status_key")
                case .none:
                    connectionStatus = ConnectionStatus(rawValue: UserDefaults.standard.integer(forKey: "\(SpotifyManager.self)_status_key")) ?? .unknown
                }
                
                var delegate = SpotifyManagerDelegate(subscriber)
                let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
                appRemote.connectionParameters.accessToken = accessToken
                appRemote.delegate = delegate
                appRemote.connect()
                
                dependencies[id] = Dependencies(
                    connectionStatus: connectionStatus,
                    appRemote: appRemote,
                    delegate: delegate,
                    subscriber: subscriber)
                
                return AnyCancellable {
                    dependencies[id] = nil
                }
            }
        }
        
        manager.destroy = { id in
            .fireAndForget {
                let statusKey = dependencies[id]?.connectionStatus ?? .unknown
                UserDefaults.standard.set(statusKey.rawValue, forKey: "\(SpotifyManager.self)_status_key")
                dependencies[id]?.appRemote.disconnect()
                dependencies[id] = nil
            }
        }
        
        manager.handleAuthorization = { id, url in
            .fireAndForget {
                let parameters = dependencies[id]?.appRemote.authorizationParameters(from: url)
                
                if let accessToken = parameters?[SPTAppRemoteAccessTokenKey] {
                    let status = ConnectionStatus.connected
                    dependencies[id]?.connectionStatus = status
                    UserDefaults.standard.set(status.rawValue, forKey: "\(SpotifyManager.self)_status_key")
                    dependencies[id]?.appRemote.connectionParameters.accessToken = accessToken
                    dependencies[id]?.subscriber.send(.authorizationResult(.success(accessToken)))
                } else if let errorDescription = parameters?[SPTAppRemoteErrorDescriptionKey] {
                    dependencies[id]?.subscriber.send(.authorizationResult(.failure(Error(SpotifyError.error(errorDescription)))))
                }
            }
        }
        
        manager.authorizeSpotifyAndPlay = { id, uri in
            .fireAndForget {
                dependencies[id]?.appRemote.authorizeAndPlayURI(uri)
            }
        }
        manager.connect = { id in
            .fireAndForget {
                dependencies[id]?.appRemote.connect()
            }
        }
        
        manager.disconnect = { id in
            .fireAndForget {
                dependencies[id]?.appRemote.disconnect()
            }
        }
        
        manager.subscribe = { id, completion in
            .fireAndForget {
                dependencies[id]?.appRemote.playerAPI?.delegate = dependencies[id]?.delegate
                dependencies[id]?.appRemote.playerAPI?.subscribe(toPlayerState: completion)
            }
        }
        
        manager.unsubscribe = { id, completion in
            .fireAndForget {
                dependencies[id]?.appRemote.playerAPI?.unsubscribe(toPlayerState: completion)
            }
        }
        
        manager.getPlayerState = { id, completion in
            .fireAndForget {
                dependencies[id]?.appRemote.playerAPI?.getPlayerState(completion)
            }
        }
        manager.play = { id, completion in
            .fireAndForget {
                dependencies[id]?.appRemote.playerAPI?.play("", callback: completion)
            }
        }
        
        manager.pause = { id, completion in
            .fireAndForget {
                dependencies[id]?.appRemote.playerAPI?.pause(completion)
            }
        }
        
        manager.skipForward = { id, completion in
            .fireAndForget {
                dependencies[id]?.appRemote.playerAPI?.skip(toNext: completion)
            }
        }
        
        manager.skipBackward = { id, completion in
            .fireAndForget {
                dependencies[id]?.appRemote.playerAPI?.getPlayerState { state, error in
                    guard error == nil,
                          let playerState = state as? SPTAppRemotePlayerState else { return }
                    
                    switch playerState.playbackPosition {
                    case 0 ... 10: dependencies[id]?.appRemote.playerAPI?.skip(toPrevious: completion)
                    default: dependencies[id]?.appRemote.playerAPI?.seek(toPosition: 0, callback: nil)
                    }
                }
            }
        }
        
        manager.fetchImage = { id, track, _ in
            .fireAndForget {
                dependencies[id]?.appRemote
                    .imageAPI?
                    .fetchImage(forItem: track,
                                with: CGSize(width: 256, height: 256),
                                callback: { image, error in
                                    guard error == nil else { return }
                                    dependencies[id]?.subscriber.send(.fetchedImage(image as? UIImage))
                                })
            }
        }
        
        #if canImport(MediaPlayer)
        
        manager.setVolume = { _, level in
            .fireAndForget {
                MPVolumeView.setVolume(level)
            }
        }
        #endif
        
        return manager
    }()
}

private struct Dependencies {
    var connectionStatus: ConnectionStatus
    var appRemote: SPTAppRemote
    let delegate: SpotifyManagerDelegate
    let subscriber: Effect<SpotifyManager.Action, Never>.Subscriber
}

private var dependencies: [AnyHashable: Dependencies] = [:]

private class SpotifyManagerDelegate: NSObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    let subscriber: Effect<SpotifyManager.Action, Never>.Subscriber
    
    init(_ subscriber: Effect<SpotifyManager.Action, Never>.Subscriber) {
        self.subscriber = subscriber
    }
    
    // MARK: - SPTAppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_: SPTAppRemote) {
        subscriber.send(.didConnect)
    }
    
    func appRemote(_: SPTAppRemote, didDisconnectWithError error: Error?) {
        subscriber.send(.didDisconnect(SpotifyManager.Error(error)))
    }
    
    func appRemote(_: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        subscriber.send(.didFailConnection(SpotifyManager.Error(error)))
    }
    
    // MARK: - SPTAppRemotePlayerStateDelegate
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        let playerRestrictions = AppRemotePlaybackRestrictions(canSkipNext: playerState.playbackRestrictions.canSkipNext,
                                                               canSkipPrevious: playerState.playbackRestrictions.canSkipPrevious,
                                                               canRepeatTrack: playerState.playbackRestrictions.canRepeatTrack,
                                                               canRepeatContext: playerState.playbackRestrictions.canRepeatContext,
                                                               canToggleShuffle: playerState.playbackRestrictions.canToggleShuffle,
                                                               canSeek: playerState.playbackRestrictions.canSeek)
        
        let playerState = SpotifyPlayerState(track: AppRemoteTrack(playerState.track),
                                             isPaused: playerState.isPaused,
                                             playerRestrictions: playerRestrictions,
                                             contextURI: playerState.contextURI)
        
        subscriber.send(.playerChangedState(playerState))
    }
}
