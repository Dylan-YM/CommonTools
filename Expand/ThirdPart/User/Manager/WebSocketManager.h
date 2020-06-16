//
//  WebSocketManager.h
//  HomePlatform
//
//  Created by Liu, Carl on 04/07/2017.
//  Copyright © 2017 Honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSocketConfig.h"

typedef enum : NSUInteger {
    WebSocketStateInvalid,
    WebSocketStateConnecting,
    WebSocketStateConnected,
    WebSocketStateReconnecting,
} WebSocketState;

typedef enum : NSUInteger {
    WebSocketMessageFlagNone,
    WebSocketMessageFlagRequest,
    WebSocketMessageFlagResponse,
} WebSocketMessageFlag;

@interface WebSocketManager : NSObject

@property (readonly, nonatomic) WebSocketState state;
@property (readonly, nonatomic, nonnull) NSMutableAttributedString *webSocketResultString;

+ (WebSocketManager *_Nonnull)instance;

- (void)connect;

- (void)disconnect;

- (NSString *_Nonnull)stateTitle;

- (void)clearLog;

/**
 *  Send data with config
 *  @param messageType required
 *  @param messageData required
 *  @param messageFlag WebSocketMessageFlag enumn
 *  @param messageId optional
 *  @return messageId, or nil
 */
- (NSString *_Nullable)sendWithType:(NSString *_Nonnull)messageType data:(NSObject *_Nonnull)messageData flag:(WebSocketMessageFlag)messageFlag messageId:(NSString *_Nullable )messageId;

@end
