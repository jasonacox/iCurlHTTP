//
//  iCHAppDelegate.m
//  iCurlHTTP
//
//  Created by Jason Cox on 2/16/13.
//  Copyright (c) 2013 Jason Cox. All rights reserved.
//

#import "iCHAppDelegate.h"
#import "ssl.h"
#import "curl.h"
#import "iCHViewController.h"
// #import <sys/utsname.h>

@implementation iCHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if OPENSSL_VERSION_NUMBER < 0x1000100fL
    // OpenSSL - removed in 1.12 due to OpenSSL 1.1.1 upgrade
    SSL_load_error_strings();                /* readable error messages */
    SSL_library_init();                      /* initialize library */
#endif
    //
    // libcurl - see http://curl.haxx.se/libcurl/
    //         - library compile help - see
    //               http://seiryu.home.comcast.net/~seiryu/libcurl-ios.html
    //
    curl_global_init(0L);

    // iOS 13+ uses UIScene lifecycle (see iCHSceneDelegate) - the system calls
    // application:configurationForConnectingSceneSession:options: below to
    // hand off window creation instead of us doing it here.
    if (@available(iOS 13.0, *)) {
        return YES;
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    NSString *nibName = [iCHAppDelegate nibNameForWindow:self.window];
    self.viewController = [[iCHViewController alloc] initWithNibName:nibName bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

+ (NSString *)nibNameForWindow:(UIWindow *)window
{
#if TARGET_OS_MACCATALYST
    NSLog(@"Device = Mac");
    return @"iCHViewController_Mac";
#else
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone - make the window key/visible once to get real safe area insets, then
        // decide which nib to use. Devices with no home button (notch,
        // Dynamic Island, etc.) always report a non-zero bottom inset, so this
        // works for future hardware without hardcoding screen dimensions.
        [window makeKeyAndVisible];
        BOOL hasNotch = window.safeAreaInsets.bottom > 0;
        NSLog(@"iphone-safeAreaInsets:%@ hasNotch:%d", NSStringFromUIEdgeInsets(window.safeAreaInsets), hasNotch);
        if (hasNotch) {
            // iPhoneX - use expanded nib to accomodate top notch
            NSLog(@"Device = iPhone with notch");
            return @"iCHViewController_iPhoneX_port";
        }
        // other iPhone
        NSLog(@"Device = iPhone");
        return @"iCHViewController_iPhone_port";
    }
    // Assume this is iPad
    NSLog(@"Device = iPad");
    return @"iCHViewController_iPad_port";
#endif
}

// UIScene lifecycle (iOS 13+) - hand off to iCHSceneDelegate
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0))
{
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0))
{
    // Called when the user discards a scene session. Nothing to clean up - we
    // don't persist any scene-specific state.
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // libcurl cleanup
    curl_global_cleanup();
    
#if OPENSSL_VERSION_NUMBER < 0x1000100fL
    // openssl cleanup -- not the best - removed in 1.12 due to Openssl 1.1.1
    /VP_cleanup ();
    //ERR_free_strings();
    CRYPTO_cleanup_all_ex_data();
    sk_SSL_COMP_free (SSL_COMP_get_compression_methods());
#endif
    
}

@end
