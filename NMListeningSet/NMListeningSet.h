//
//  NMListningSet.h
//
//  Created by Murray Hughes on 12/09/13.
//  Copyright (c) 2013 NullMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMListeningSet : NSObject

// The protocol the listners must conform to
@property (nonatomic, readonly) Protocol* listeningProtocol;

// queue to invoke any protocol methods on, if NULL they will be invoked on the thread called on
@property (nonatomic, assign) dispatch_queue_t queue;

//
// constructor... listeningSetForProtocol:@protocol(MySpecialProtocol)
+ (id) listeningSetForProtocol:(Protocol*) protocol;

// Add a listner, it will only be added if it conforms to the listeningProtocol
- (void) registerListener:(id) listner;

// Remove listner. Manual unregister only, listner object will automatically be removed
- (void) unregisterListener:(id) listner;

// Remove all
- (void) unregisterAllListeners;

@end
