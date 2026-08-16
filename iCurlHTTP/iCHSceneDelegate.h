//
//  iCHSceneDelegate.h
//  iCurlHTTP
//
//  UIScene lifecycle entry point (iOS 13+). iCHAppDelegate still handles the
//  window directly on iOS 12, since that predates UIScene.
//

#import <UIKit/UIKit.h>

API_AVAILABLE(ios(13.0))
@interface iCHSceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
