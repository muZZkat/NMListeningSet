//
//  NMListeningSet.m
//
//  Created by Murray Hughes on 12/09/13.
//  Copyright (c) 2013 NullMonkey. All rights reserved.
//

#import "NMListeningSet.h"
#import <objc/runtime.h>

@interface NMProtocolObject : NSObject
@end
@implementation NMProtocolObject
@end

@interface NMListeningSet ()

// NSHashTable is modeled after NSSet but provides different options, in particular to support weak relationships.
@property (strong, nonatomic) NSHashTable* listenerTable;

// The protocol the listeners are conforming to
@property (strong, nonatomic, readwrite) Protocol* listeningProtocol;

// A dummy object used to test if the selector is part of the listening protocol
@property (strong, nonatomic) NMProtocolObject* protocolObject;

@end

@implementation NMListeningSet

+ (id) listeningSetForProtocol:(Protocol *)protocol
{
    NMListeningSet* set = [[self alloc] init];
    set.listeningProtocol = protocol;
    return set;
}

#pragma mark -
#pragma Properties

- (NSHashTable *)listenerTable
{
    if(_listenerTable==nil) {
        _listenerTable = [NSHashTable weakObjectsHashTable];
    }
    return _listenerTable;
}

- (NMProtocolObject*) protocolObject
{
    if (_protocolObject==nil) {

        NSAssert(self.listeningProtocol, @"NMListeningSet: Listening protocol not set, please use 'listeningSetForProtocol' constructor");
    
        _protocolObject = [NMProtocolObject new];
        class_addProtocol([NMProtocolObject class], self.listeningProtocol); // add our listing protocol
    }
    
    return _protocolObject;
}


#pragma mark -
#pragma Public 

- (void) registerListener:(id) listner
{
    if([listner conformsToProtocol:self.listeningProtocol])
    {
		[self.listenerTable addObject:listner];
    }
}

- (void) unregisterListener:(id) listner
{
	[self.listenerTable removeObject:listner];
}


- (void) unregisterAllListeners
{
	[self.listenerTable removeAllObjects];
}

#pragma mark -
#pragma Invocation

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    
    if(!signature)
    {
        // check and make sure the selector conforms to the protocol object
        if([self.protocolObject methodSignatureForSelector:aSelector])
        {
			NSHashTable* listeners = [self.listenerTable copy];
			for(id observer in listeners)
            {
                if([observer respondsToSelector:aSelector])
                {
                    return [observer methodSignatureForSelector:aSelector];
                }
            }
            
            // none of the observers respond, just return a void signature
            // so it doesn't cause a does not responsd to selector exception
            signature = [NSMethodSignature signatureWithObjCTypes: "@^v^c"];

        }
        else
        {
            NSLog(@"NMListeningSet: The '%@' selector isn't part of the listening protocol '%@'", NSStringFromSelector(aSelector), NSStringFromProtocol(self.listeningProtocol));
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)anInvocation
{
	NSHashTable* listeners = [self.listenerTable copy];
    for(id observer in listeners)
    {
        if([observer respondsToSelector:[anInvocation selector]])
        {
            if(self.queue) {
                [anInvocation retainArguments];
                dispatch_async(self.queue, ^{
                    [anInvocation invokeWithTarget:observer];
                });
            } else {
                [anInvocation invokeWithTarget:observer];
            }
            
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if([super respondsToSelector:aSelector])
    {
        return YES;
    }
    
	NSHashTable* listeners = [self.listenerTable copy];
    for(id observer in listeners)
    {
        if([observer respondsToSelector:aSelector])
        {
            return YES;
        }
    }
    
    return NO;
}


- (NSString *)description
{
    return @"hello";
}

@end









