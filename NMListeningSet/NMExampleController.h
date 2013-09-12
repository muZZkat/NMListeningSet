//
//  NMExampleController.h
//  TestingListner
//
//  Created by Murray Hughes on 12/09/13.
//  Copyright (c) 2013 NullMonkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMListeningSet.h"

@protocol NMExampleControllerListener <NSObject>

@optional
- (void) exampleDidSayHelloWorldWithMessage:(NSString*) message;
- (void) exampleDidSaysayGoodbyeWorld;

- (void) exampleDidSayNever;

@end

@interface NMExampleController : NSObject

- (void) sayHelloWorldWithMessage:(NSString*) message;
- (void) sayGoodbyeWorld;

- (void) sayNever;


// Listener Registration

- (void) registerListener:(id<NMExampleControllerListener>) listener;
- (void) unregisterListener:(id<NMExampleControllerListener>) listener;
- (void) unregisterAllListeners;

@end
