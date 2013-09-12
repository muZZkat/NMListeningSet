//
//  NMExampleController.m
//  TestingListner
//
//  Created by Murray Hughes on 12/09/13.
//  Copyright (c) 2013 NullMonkey. All rights reserved.
//

#import "NMExampleController.h"
#import "NMListeningSet.h"

@interface NMExampleController ()

@property (nonatomic, retain) NMListeningSet<NMExampleControllerListener>* listeners;

@end


@implementation NMExampleController


- (NMListeningSet<NMExampleControllerListener> *) listners
{
    if(_listeners==nil)
    {
        _listeners = (NMListeningSet<NMExampleControllerListener>*)[NMListeningSet listeningSetForProtocol:@protocol(NMExampleControllerListener)];
        
    }
    
    return _listeners;
}



- (void) sayHelloWorldWithMessage:(NSString*) message
{
    // just call protocol method on the Listening set and it will be forwarded
    // to all the listeners
    [self.listeners exampleDidSayHelloWorldWithMessage:message];
}

- (void) sayGoodbyeWorld
{
    [self.listeners exampleDidSaysayGoodbyeWorld];
}

- (void) sayNever
{
    [self.listeners exampleDidSayNever];
}



- (void) registerListener:(id<NMExampleControllerListener>)listener
{
    [self.listners registerListener:listener];
}

- (void) unregisterListener:(id<NMExampleControllerListener>)listener
{
    [self.listners unregisterListener:listener];
}

- (void) unregisterAllListeners
{
    [self.listners unregisterAllListeners];
}


@end
