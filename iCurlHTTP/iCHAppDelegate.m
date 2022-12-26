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
    
    // Determine hardware
    /*
    struct utsname systemInfo;
            uname(&systemInfo);
    
    NSLog(@"%@", [NSString stringWithCString:systemInfo.machine
                             encoding:NSUTF8StringEncoding]);
    */
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    // The ** indicates ones that need the notch accomodation
    // iPhone 6 = 1334 and 6s = 1334 and 6s Plus = 2208
    // iphone 7 = 1334 and 7 Plus = 2208
    // iPhone 8 = 1334   8 Plus = 2208   SE = 1136
    // ** iPhone XR = 1624
    // ** iPhone X or XS = 2436
    // ** iPhone 11 = 1792
    // ** iPhone 11 Pro = 2688
    // ** iPhone 12 = 2532
    // ** iPhone 12 Pro = 2532
    // ** iPHone 12 Pro Max = 2778
    // ** iPhone 12 mini = (real) 2340 (simulator) 2436
     

#if TARGET_OS_MACCATALYST
    NSLog(@"Device = Mac");
    
    self.viewController = [[iCHViewController alloc] initWithNibName:@"iCHViewController_Mac" bundle:nil];

#else
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPHone
        int height = (int)[[UIScreen mainScreen] nativeBounds].size.height;
        int width = (int)[[UIScreen mainScreen] nativeBounds].size.width;
        NSLog(@"iphone-height:%d -width:%d",height,width);
        if (height == 2436 || height == 1624 || height == 1792 || height == 2688 || height == 2778 || height == 2532 || height == 2340)
        {
            // iPhoneX - use expanded nib to accomodate top notch
            NSLog(@"Device = iPhone with notch");
            self.viewController = [[iCHViewController alloc] initWithNibName:@"iCHViewController_iPhoneX_port" bundle:nil];
        } else {
            // other iPhone
            NSLog(@"Device = iPhone");
            self.viewController = [[iCHViewController alloc] initWithNibName:@"iCHViewController_iPhone_port" bundle:nil];
        }
    } else {
        // Assume this is iPad
        NSLog(@"Device = iPad");
        // iPad Device
        if ([[versionCompatibility objectAtIndex:0] intValue] >= 6) { /// iOS6+ is installed
            //NSLog(@"iPad IOS Version 6 or newer - Using AutoSize NIB");  // portrait and landscape views
            self.viewController = [[iCHViewController alloc] initWithNibName:@"iCHViewController_iPad_port" bundle:nil];
        } else { /// iOS5 is installed
            //NSLog(@"iPad IOS Version 5 or older - Using Static NIB");  // portrait view only
            self.viewController = [[iCHViewController alloc] initWithNibName:@"iCHViewController_iPad_port" bundle:nil];
        }
    }
#endif
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
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
