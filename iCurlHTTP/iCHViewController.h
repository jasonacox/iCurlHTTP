//
//  iCHViewController.h
//  iCurlHTTP
//
//  Created by Jason Cox on 2/16/13.
//  Copyright (c) 2013 Jason Cox. All rights reserved.
//  www.jasonacox.com/icurlhttp
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

// libcurl include
#import "ssl.h"
#import "curl.h"
#import "iCHColors.h"

//[UIColor secondarySystemBackgroundColor]
@interface iCHViewController : UIViewController  <UIActionSheetDelegate,UIPrintInteractionControllerDelegate,MFMailComposeViewControllerDelegate>
{
    
    IBOutlet UITextField *_urlText;
    IBOutlet UITextView *_resultText;
    IBOutlet UISegmentedControl *_httpReq;
    IBOutlet UISegmentedControl *_browserType;
    IBOutlet UISegmentedControl *_verbose;
    IBOutlet UIProgressView *_progress;
    IBOutlet UIButton *_goButton;
    IBOutlet UIButton *_shareButton;
    IBOutlet UIButton *_userButton;
    IBOutlet UIButton *_userReset;
    IBOutlet UITableView *_urlDropdown;
    IBOutlet UILabel *_appTitle;
    IBOutlet UILabel *_timings;
   
    // global data
    CURL *_curl;
	struct curl_slist *_headers;
    struct curl_slist *_resolvehost;     // DNS Resolve Override
	NSData *_dataToSend;
	size_t _dataToSendBookmark;
	NSMutableData *_dataReceived;
    int globalReset;
    NSMutableArray *favoriteURLs;   // used for history
    NSMutableArray *favoritePOST;   // used for history
    NSMutableArray *favoriteHEADER; // used for history
    // UIActionSheet *actionSheet;  // Deprecated
    NSString *cacertPath;           // path to cacert.pem file
    int iPhoneWidth;              
    
    // settings data
    NSMutableDictionary *settingsdata;  // settings data for plist
    NSString *userAgent;    // user agent - browser
    NSString *userName;     // username for auth
    NSString *userPass;     // password for auth
    BOOL userAuthBasic;
    BOOL userAuthDigest;
    BOOL userAuthNTLM;
    BOOL userAuthNegotiate;
    BOOL userAuthAny;
    NSString *userHeaders;  // custom additional headers
    NSString *userPost;     // POST data urlencoded
    BOOL userInsecure;      // SSL insecure mode
    NSNumber *userTimeout;
    NSNumber *userConnectTimeout;
    BOOL userSSLv3;         // use SSLv3 Protocol
    NSString *redirect_url; // redirect URL detected in response
    BOOL userHTTP2;         // use HTTP2 Protocol
    BOOL userCertDetail;    // additional cert chain details
    BOOL userIPv4;          // support IPv4 address resolution
    BOOL userIPv6;          // support IPv6 address resolution
    NSString *userResolve;   // DNS resolve override
    
}
@property (retain, nonatomic) UITextField *_urlText;
@property (retain, nonatomic) UITextView *_resultText;
@property (retain, nonatomic) UISegmentedControl *_httpReq;
@property (retain, nonatomic) UISegmentedControl *_browserType;
@property (retain, nonatomic) UIProgressView *_progress;
@property (retain, nonatomic) UISegmentedControl *_verbose;
@property (retain, nonatomic) UIButton *_goButton;
@property (retain, nonatomic) UIButton *_shareButton;
@property (retain, nonatomic) UIButton *_userButton;
@property (retain, nonatomic) UIButton *_userReset;
@property (retain, nonatomic) UILabel *_appTitle;
@property (retain, nonatomic) UILabel *_timings;


- (IBAction)Go: (id)sender;
- (IBAction)DropDown: (id)sender;
- (IBAction)Share: (id)sender;
- (IBAction)User: (id)sender;
- (IBAction)Reset: (id)sender;
// - (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)loadSettings;
- (IBAction)saveSettings;
- (IBAction)favoritesReset;
- (IBAction)sharePrint;
- (IBAction)shareEmail;
- (IBAction)shareCopy;
- (IBAction)ReqType: (id)sender;
- (IBAction)initLibcurl;

@end




