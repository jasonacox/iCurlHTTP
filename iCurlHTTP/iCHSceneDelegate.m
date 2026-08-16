//
//  iCHSceneDelegate.m
//  iCurlHTTP
//

#import "iCHSceneDelegate.h"
#import "iCHAppDelegate.h"
#import "iCHViewController.h"

@implementation iCHSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions
{
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;

    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    [self.window makeKeyAndVisible];

    NSString *nibName = [iCHAppDelegate nibNameForWindow:self.window];
    iCHViewController *viewController = [[iCHViewController alloc] initWithNibName:nibName bundle:nil];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}

@end
