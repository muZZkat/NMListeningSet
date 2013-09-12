//
//  NMAppDelegate.m
//  NMListeningSet
//
//  Created by Murray Hughes on 12/09/13.
//  Copyright (c) 2013 NullMonkey. All rights reserved.
//

#import "NMAppDelegate.h"
#import "NMExampleController.h"


@interface NMAppDelegate () <NMExampleControllerListener>

@property (nonatomic, strong) NMExampleController* exampleController;
@property (nonatomic, strong) NMAppDelegate* anotherAppDelegate;

@end

@implementation NMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    self.exampleController = [NMExampleController new];

    // Register as a Lister
    [self.exampleController registerListener:self];

    // Create a 2nd app delegate and register that as a delegate
    self.anotherAppDelegate = [NMAppDelegate new];
    [self.exampleController registerListener:self.anotherAppDelegate];

    // Register a 3rd, the listning set uses weak references and automatically
    // removes listeners when they are dealloced. The 3rd delegate will actuallly
    // be removed before any events are fired.
    [self.exampleController registerListener:[NMAppDelegate new]];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.exampleController sayHelloWorldWithMessage:@"I love cupcakes"];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.exampleController sayGoodbyeWorld];
}


#pragma mark -
#pragma mark NMExampleControllerListener

- (void)exampleDidSayHelloWorldWithMessage:(NSString *)message
{
    NSLog(@"%@: exampleDidSayHelloWorldWithMessage: %@", self, message);
}

- (void)exampleDidSaysayGoodbyeWorld
{
    NSLog(@"%@: exampleDidSaysayGoodbyeWorld", self);
}

// All methods are optional, just implement the ones you need
// - (void) exampleDidSayNever;

@end
