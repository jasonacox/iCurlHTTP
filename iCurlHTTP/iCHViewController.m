//
//  iCHViewController.m
//  iCurlHTTP
//
//  Created by Jason Cox on 2/15/13.
//  Copyright (c) 2013 Jason Cox. All rights reserved.
//  www.jasonacox.com/icurlhttp
//
//  "I fight for the users" - Tron
//  ------------------------------
//
//    HTTP Server Response Diagnostic Tool
//
//    iCurlHTTP is a simple, easy to use iOS app that allows you to run cURL like tests, simulating different web
//    browsers to retrive the raw HTTP headers and HTML response from the web servers.
//
//    GET and HEAD Requests (GET, HEAD, POST, PUT, DELETE, OPTIONS and TRACE on iPad)
//    SSL Support - https requests with some basic cert and handshake information
//    Keeps a history of URLs tested and provides them in a dropdown for easy repeated testing
//    Simulates curl, iPhone, iPad, Safari and IE browsers (Chrome and Firefox on iPad)
//    Set custom User-Agent, Host Headers, HTTP Authentication, SSL Mode and POST Data (iPad only) [v1.3]
//    Share Feature to send output to Clipboard, Printer and Email [v1.3]
//    Simple single-view interface with realtime result screen
//    iPhone and iPad support
//
//  --------------
//  REVISION NOTES
//
//  2/15/2013
//   v1.0 - First Version
//
//  3/25/2013
//   v1.1 - Added OpenSSL+libcurl library for enhanced SSL information (eg. cert expiration, verification)
//          Increased libcurl buffer to 32k to accelerate transfer of large HTML documents
//          Added warning and cancelation option for larger HTML downloads (>250k)
//          Bug Fix: Corrected PUT method stickiness (incorrectly ran PUT http method even after switching)
//          Bug Fix: Corrected URL dropdown table bug in landscape mode (adjusting for keyboard offset)
//
//  9/5/2013
//   v1.2 - Updated to use new iOS 7 SDK and fix Basic/Detail toggle button alignment in iOS 7.
//          Added HTTP timing details to View and Detail Output (Name Lookup, TCP Connect, SSL Handshake,
//          First Byte and Total)
//
//  6/15/2014
//   v1.3 - Share Feature - Send output to Clipboard, Printer and Email
//          User Settings - Adjust User-Agent, Custom Headers, POST Data, Authentication and SSL Mode
//          Updates - New libcurl (7.37.0) and openssl (1.0.1h) libraries.
//          Updated user-agents
//
//  2/19/2015
//   v1.4 - POST Requests added to iPhone.
//          URL history now includes POST and HEADER data
//          URL history can be cleared in User settings menu
//          Added user defined timeout setting (default 30s)
//          iOS 8 - iPhone6 and iPhone6 Plus Support
//          Updates - New libcurl (7.40.0) and openssl (1.0.1l) libraries (SSLv3 disabled by default)
//          Security Options - User setting to allow Forced SSLv3 for testing
//
//  2/6/2016
//   v1.5 - Added 301/302 redirect following option.
//          Updated User and Share buttons with icons intead of text.
//          Added Chrome to iPhone browser emulation options.
//          Updates - New libcurl (7.47.1) and openssl (1.0.1r) libraries
//
//  9/5/2016
//   v1.6 - Added HTTP2 Protocol Support via nghttp2 (1.14.0) library
//          Added Certificate Chain Details for HTTPS Sessions (Detail Mode)
//          Added Support for Authentication Credentials in URL (e.g. https://user:pass@jasonacox.com/gettest.php)
//          Added Setting Toggles for IPv4 and IPv6 Address Resolution
//          Updates - New libcurl (7.50.1) and openssl (1.0.1t) libraries
//
//  10/15/2016
//   v1.7 - Added DNS Resolve Option for Manual Address Resolution (eg. HOST:PORT:ADDRESS)
//          iOS 10 - iPhone7 and iPhone7 Plus Support
//          Updates - New libcurl (7.50.3), openssl (1.0.1u), nghttp2 (1.15.0) libraries
//
//  10/31/2016
//   v1.8 - Perforamnce Improvements and Bug Fixes to Address User Interface Related Crashes
//          Updated iCurlHTTP User Agent Default
//          Added user defined DNS lookup & connection timeout setting (default 5s)
//
//  12/23/2016
//   v1.9 - Bug Fix to Address Compatability Issues with iOS 9 
//          Updates - New libcurl (7.52.1), openssl (1.0.1u), nghttp2 (1.17.0) libraries
//
//  11/11/2017
//   v1.10- Bug Fix to Address Compatability Issues with HTTP2
//          Updates - New libcurl (7.56.1), openssl (1.0.2m), nghttp2 (1.27.0) libraries
//
//  4/21/2018
//   v1.11- iOS 12 - iPhone X Support
//          Updates - New libcurl (7.60.0), openssl (1.0.2o), nghttp2 (1.32.0) libraries
//          Cleanup - Upgraded UIAlertView to UIAlertController
//          Cleanup - Added userWait to stop download thread while a user dialog is open
//
//  4/4/2019
//   v1.12- OpenSSL 1.1.1 Upgrade
//          Updates - New libcurl (7.64.1), openssl (1.1.1b), nghttp2 (1.37.0) libraries
//          Updates - Supporting new iPhone Models (XR, XS, XS Max) and iOS 12.2
//
//  1/1/2020
//   v1.13- iOS 13 - Dark Mode Support
//          Updates - New libcurl (7.67.0), openssl (1.1.1d), nghttp2 (1.40.0) libraries
//
//  9/12/2020
//   v1.14- PUT Support for iPhone
//          Bug Fix - SSLv3 Added for Testing (Force SSLv3 Setting)
//          Updates - New libcurl (7.72.0), openssl (1.1.1g), nghttp2 (1.41.0) libraries
//
//  12/29/2020
//   v1.15- Support for new iPhone 12
//          Added support for new iPhone 12 models (12, Pro, Pro Max, Mini)
//          Updates - New libcurl (7.74.0), openssl (1.1.1i), nghttp2 (1.42.0) libraries
//
//  1/2/2021
//   v1.16- Support for new iPhone 12 (Redo)
//          Added support for new iPhone 12 models (12, Pro, Pro Max, Mini) in v.1.15
//          Bug Fix - SSLv3 Added for Testing (Force SSLv3 Setting)
//          Mac Catalyst Support Added
//
//  5/29/2022
//   v1.17- Support for new iPhone 13
//          Updates - New libcurl (7.83.1), openssl (1.1.1o), nghttp2 (1.47.0) libraries
//          Updates - Browser User Agents Updated and replaced IE with Edge.
//
//  7/17/2022
//   v1.18- Fix Bug with iPhone 13 Pro
//          Updates - New libcurl (7.84.0), openssl (1.1.1q), nghttp2 (1.48.0) libraries
//
// ** WISH LIST **
//          Search box for result text / regex even better
//          Method toggle instead of selector box to allow all verbs for iphone
//          Text Formatted Output Window
//          Redo old xib
//          JSON or HTML Human Readable Display Option
//          Multiple color options or text sizes
//          Multiple profiles (settings, user-agents, etc)
//          HTTP/3 Support
//


#import "iCHViewController.h"
#import "iCHSettingsViewController.h"
#import "iCHSegmentedOverride.h"
#import "iCHStringTrunc.h"

// global
bool largefileAlert;
long long downloadedSize;
long long fileSize;
bool waitForUser; // dialog box freeze work
//bool autoRedirect; // if user selected redirection try to follow

// Create private interface
@interface iCHViewController (Private)
- (size_t)copyUpToThisManyBytes:(size_t)bytes intoThisPointer:(void *)pointer;
- (void)insertText:(NSString *)text;
- (void)insertTextv:(NSString *)text;
- (void)receivedData:(NSData *)data;
- (void)rewind;
- (void)updateProgress:(double *)per;
- (int)DOglobalReset;
@end

//
// CURL Methods
//

// Curl methods to process response
int iCHCurlDebugCallback(CURL *curl, curl_infotype infotype, char *info, size_t infoLen, void *contextInfo) {
	iCHViewController *vc = (__bridge iCHViewController *)contextInfo;
	NSData *infoData = [NSData dataWithBytes:info length:infoLen];
	NSString *infoStr = [[NSString alloc] initWithData:infoData encoding:NSUTF8StringEncoding];
    //NSLog(@"> In iCHCurlDebugCallback [%zu:%s]",infoLen,info);
	if (infoStr) {
		infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];	// convert CR/LF to just LF
		infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];	// convert CR to LF
		switch (infotype) {
			case CURLINFO_DATA_IN:
				[vc insertText:infoStr];
				break;
			case CURLINFO_DATA_OUT:
				[vc insertText:[infoStr stringByAppendingString:@"\n"]];
				break;
			case CURLINFO_HEADER_IN:
				[vc insertText:[@"" stringByAppendingString:infoStr]];
				break;
			case CURLINFO_HEADER_OUT:
				infoStr = [infoStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\n>> "];
				[vc insertTextv:[NSString stringWithFormat:@">> %@\n", infoStr]];
				break;
			case CURLINFO_TEXT:
				[vc insertTextv:[@"-- " stringByAppendingString:infoStr]];
				break;
			default:	// ignore the other CURLINFOs
                break;
		}
	}
    
	return 0;
}

curlioerr iCHCurlIoctlCallback(CURL *handle, int cmd, void *clientp) {
	iCHViewController *vc = (__bridge iCHViewController *)clientp;
    //NSLog(@"> In iCHCurlIoctlCallback");
	if (cmd == CURLIOCMD_RESTARTREAD)	// this is our cue to rewind _dataToSendBookmark back to the start
	{
		[vc rewind];
		return CURLIOE_OK;
	}
	return CURLIOE_UNKNOWNCMD;
}


size_t iCHCurlReadCallback(void *ptr, size_t size, size_t nmemb, void *userdata) {
	const size_t sizeInBytes = size*nmemb;
	iCHViewController *vc = (__bridge iCHViewController *)userdata;
	
    //NSLog(@"> In iCHCurlReadCallback %zd",sizeInBytes);
	return [vc copyUpToThisManyBytes:sizeInBytes intoThisPointer:ptr];
}


size_t iCHCurlWriteCallback(char *ptr, size_t size, size_t nmemb, void *userdata) {
	const size_t sizeInBytes = size*nmemb;
	iCHViewController *vc = (__bridge iCHViewController *)userdata;
	//NSData *data = [[NSData alloc] initWithBytes:ptr length:sizeInBytes];

    //NSLog([NSString stringWithFormat:@"> In iCHCurlWriteCallback - globalReset = %d",[vc globalReset]]);
	//[vc receivedData:data];
    
    //NSLog([NSString stringWithFormat:@"> In iCHCurlWriteCallback - globalReset = %d",[vc globalReset]]);
    //NSLog(@"> In iCHCurlWriteCallback %zd",sizeInBytes);
    if([vc DOglobalReset]>1) return 0;
    else return sizeInBytes;
}

int count=0;

int iCHCurlProgressCallback(void *clientp, int64_t dltotal, int64_t dlnow, int64_t ultotal, int64_t ulnow) {
    //int progress_callback(void *clientp,   curl_off_t dltotal,   curl_off_t dlnow,   curl_off_t ultotal,   curl_off_t ulnow);
    double perProgress;
    if(dltotal < 1.0) {
        dltotal = 200000.0; // guess
        if (dltotal < fileSize) dltotal = fileSize;
        //if(dlnow > 90000.0) dltotal = dlnow*1.1; // ensure guess is always 10% more than actual
    }
    fileSize = dltotal;
    perProgress = dlnow/dltotal;
    //if(perProgress==0.0) perProgress = 0.01; // force 1% indicator
    if(perProgress>0.95) perProgress = 0.95; // force 5% buffer until closed by  main thread

    //NSLog(@"iCHCurlProgressCallback (%d): %lld/%lld = %1.2f", count++, dlnow, dltotal, perProgress);

    iCHViewController *vc = (__bridge iCHViewController *)clientp;
    [vc updateProgress:&perProgress];
    /*  NOTE: this section moved to insertText function
    // check for large file - present option to cancel
    if((dlnow > 200000 || (dltotal > 200000 && dlnow > 10000)) && !largefileAlert) {
        
        largefileAlert = TRUE;
        waitForUser = TRUE;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Large File Warning"
                                                        message:@"HTML download exceeds 200k"
                                                       delegate:vc
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alertView setTag:12];
        [alertView show];

    }
     */
    // check for any cancellation request
    if([vc DOglobalReset]>1) return 1;
    else return 0;
}

//
//  iCHViewController
//

@implementation iCHViewController

@synthesize _httpReq;
@synthesize _resultText;
@synthesize _urlText;
@synthesize _browserType;
@synthesize _progress;
@synthesize _verbose;
@synthesize _goButton;
@synthesize _shareButton;
@synthesize _userButton;
@synthesize _appTitle;
@synthesize _timings;
@synthesize _userReset;

// Init curl and assign method calls
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    //NSLog(@"> In initWithNibName");
    // send message to super to get our address
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {

        [self initLibcurl]; // initialize libcurl
        
        // Global Reset
        globalReset = 0;
	}
	return self;
}

// function to initialize libcurl
- (void)initLibcurl
{
   
    //_dataReceived = [[NSMutableData alloc] init];
    _curl = curl_easy_init();
    
    // Some settings I recommend you always set:CURLAUTH_BASIC
    curl_easy_setopt(_curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);	// support basic, digest, and NTLM authentication
    curl_easy_setopt(_curl, CURLOPT_NOSIGNAL, 0L);	// try not to use signals
    curl_easy_setopt(_curl, CURLOPT_USERAGENT, curl_version());	// set a default user agent
    
    // CA root certs - loaded into project from libcurl http://curl.haxx.se/ca/cacert.pem
    cacertPath = (NSString *)[[NSBundle mainBundle] pathForResource:@"cacert" ofType:@"pem"];
    curl_easy_setopt(_curl, CURLOPT_CAINFO, [cacertPath UTF8String]); // set root CA certs
    
    // Update curl options for iCurlHTTP
    curl_easy_setopt(_curl, CURLOPT_VERBOSE, 1L);	// turn on verbose
    curl_easy_setopt(_curl, CURLOPT_DEBUGFUNCTION, iCHCurlDebugCallback);  // function to get debug data to view
    curl_easy_setopt(_curl, CURLOPT_DEBUGDATA, self);
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, iCHCurlWriteCallback);  // function to get write data to view
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA, self);	// prevent libcurl from writing the data to stdout
    
    // CURLOPT_NOPROGRESS =0L
    curl_easy_setopt(_curl, CURLOPT_NOPROGRESS, 0L);
    //curl_easy_setopt(_curl, CURLOPT_PROGRESSFUNCTION, iCHCurlProgressCallback);
    //curl_easy_setopt(_curl, CURLOPT_PROGRESSDATA, self);  // libcurl will pass back dl data progress
    curl_easy_setopt(_curl, CURLOPT_XFERINFOFUNCTION, iCHCurlProgressCallback);
    curl_easy_setopt(_curl, CURLOPT_XFERINFODATA, self);  // libcurl will pass back dl data progress
    
    // Adjust curl defaults
    curl_easy_setopt(_curl, CURLOPT_TIMEOUT, 60L); // seconds for entire curl operation
    curl_easy_setopt(_curl, CURLOPT_CONNECTTIMEOUT, 10L); // seconds for DNS lookup and server to connect
    curl_easy_setopt(_curl, CURLOPT_MAXCONNECTS, 0L); // this should disallow connection sharing
    curl_easy_setopt(_curl, CURLOPT_FORBID_REUSE, 1L); // enforce connection to be closed
    curl_easy_setopt(_curl, CURLOPT_DNS_CACHE_TIMEOUT, 0L); // Disable DNS cache
    
    // SSL
    curl_easy_setopt(_curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_DEFAULT); // Force TLSv1 protocol - Default
    // Explicitly allow all ciphers, including weak ciphers
    NSString *sslCipherList = @"ALL"; // @"ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:SRP-DSS-AES-256-CBC-SHA:SRP-RSA-AES-256-CBC-SHA:SRP-AES-256-CBC-SHA:DHE-DSS-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA256:DHE-RSA-AES256-SHA:DHE-DSS-AES256-SHA:DHE-RSA-CAMELLIA256-SHA:DHE-DSS-CAMELLIA256-SHA:ECDH-RSA-AES256-GCM-SHA384:ECDH-ECDSA-AES256-GCM-SHA384:ECDH-RSA-AES256-SHA384:ECDH-ECDSA-AES256-SHA384:ECDH-RSA-AES256-SHA:ECDH-ECDSA-AES256-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:CAMELLIA256-SHA:PSK-AES256-CBC-SHA:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:SRP-DSS-AES-128-CBC-SHA:SRP-RSA-AES-128-CBC-SHA:SRP-AES-128-CBC-SHA:DHE-DSS-AES128-GCM-SHA256:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES128-SHA256:DHE-DSS-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA:DHE-RSA-SEED-SHA:DHE-DSS-SEED-SHA:DHE-RSA-CAMELLIA128-SHA:DHE-DSS-CAMELLIA128-SHA:ECDH-RSA-AES128-GCM-SHA256:ECDH-ECDSA-AES128-GCM-SHA256:ECDH-RSA-AES128-SHA256:ECDH-ECDSA-AES128-SHA256:ECDH-RSA-AES128-SHA:ECDH-ECDSA-AES128-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:SEED-SHA:CAMELLIA128-SHA:IDEA-CBC-SHA:PSK-AES128-CBC-SHA:ECDHE-RSA-RC4-SHA:ECDHE-ECDSA-RC4-SHA:ECDH-RSA-RC4-SHA:ECDH-ECDSA-RC4-SHA:RC4-SHA:RC4-MD5:PSK-RC4-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:SRP-DSS-3DES-EDE-CBC-SHA:SRP-RSA-3DES-EDE-CBC-SHA:SRP-3DES-EDE-CBC-SHA:EDH-RSA-DES-CBC3-SHA:EDH-DSS-DES-CBC3-SHA:ECDH-RSA-DES-CBC3-SHA:ECDH-ECDSA-DES-CBC3-SHA:DES-CBC3-SHA:PSK-3DES-EDE-CBC-SHA:EDH-RSA-DES-CBC-SHA:EDH-DSS-DES-CBC-SHA:DES-CBC-SHA:EXP-EDH-RSA-DES-CBC-SHA:EXP-EDH-DSS-DES-CBC-SHA:EXP-DES-CBC-SHA:EXP-RC2-CBC-MD5:EXP-RC4-MD5";
    curl_easy_setopt(_curl, CURLOPT_SSL_CIPHER_LIST, [sslCipherList UTF8String]);
    curl_easy_setopt(_curl, CURLOPT_CERTINFO, 1L); // attempt to pull all cert chains
    
    _resolvehost = NULL;
}

// deallocate memory and shut down curl
- (void)dealloc
{
	if (_headers)
		curl_slist_free_all(_headers);
	curl_easy_cleanup(_curl);
    if (_resolvehost) curl_slist_free_all(_resolvehost);
}

// View loaded - setup the interface and load pervious URL favorites/history
- (void)viewDidLoad
{
    [super viewDidLoad];
    BOOL success;
    NSError *error;
    
    // The following is required to eliminate errors related to UICollectionView
    // It is probably related to the legacy xib AutoSize iCurlHTTP uses
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Remove title for iOS > 7
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[versionCompatibility objectAtIndex:0] intValue] >= 7) { /// iOS7+ is installed
        // _appTitle.text = @""; // remove title for iOS 7+
        _appTitle.hidden=YES;
    } else {
        _appTitle.text = [@"iCurlHTTP v" stringByAppendingFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    }
    
    // Display version and library info in view
    _resultText.text = [@"" stringByAppendingFormat:@"iCurlHTTP v%@\n[HTTP Server Response Diagnostic Tool]\n(c) 2022 Jason A. Cox\n\nUsing: %s\n\n\n\n\n",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], curl_version()];
    
    // Format UISegmentedControls Font
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"STHeitiSC-Medium" size:12.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [_httpReq bluetextColor];
    [_browserType bluetextColor];
    [_verbose bluetextColor];
    
    // Expand Segment if we have room for PUT on newer / larger iPhones
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && ((int)[[UIScreen mainScreen] nativeBounds].size.width >= 750)) {
        // [_httpReq setApportionsSegmentWidthsByContent:YES]; // proportional spacing
        CGRect frame = _httpReq.frame;
        // NSLog(@"%@", [@"" stringByAppendingFormat:@"width=%f height=%f x=%f y=%f", frame.size.width, frame.size.height, frame.origin.x, frame.origin.y]);
        frame.size.width = 175;
        [_httpReq setFrame:frame];
        [_httpReq insertSegmentWithTitle:(@"PUT") atIndex:(3) animated:YES];
    }
    userAgent = [@"" stringByAppendingFormat:@"iCurlHTTP/%@ %s", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], curl_version()];
    userName = @"";
    userPass = @"";
    _progress.progress = 0.0; // start progress bar at zero
    _progress.hidden = YES;

    // hide dropdown
    _urlDropdown.hidden=YES;
    
    // add rounded corners to textviews and dropdown
    _urlDropdown.clipsToBounds=YES;
    _urlDropdown.layer.cornerRadius = 5.0f;
    _urlText.layer.borderWidth = 1.0f;
    _urlText.layer.borderColor = [[UIColor systemBlueColor] CGColor];
    _urlText.layer.cornerRadius = 5.0f;
    _resultText.clipsToBounds = YES;
    _resultText.layer.cornerRadius = 5.0f;
    _resultText.layer.borderWidth = 1.0f;
    _resultText.layer.borderColor = [[UIColor systemBlueColor] CGColor];
     [_resultText setTextColor:[UIColor blackColor]];
    
    // Support for iOS 13 and Dark Mode
    if (@available(iOS 13.0, *)) {
        // for iOS 13 add borders to segmented controls
        _verbose.layer.borderWidth = 1.0f;
        _verbose.layer.borderColor = [[UIColor UIBORDER] CGColor];
        _httpReq.layer.borderWidth = 1.0f;
        _httpReq.layer.borderColor = [[UIColor UIBORDER] CGColor];
        _browserType.layer.borderWidth = 1.0f;
        _browserType.layer.borderColor = [[UIColor UIBORDER] CGColor];
        // Dark Mode On
           if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
               // iOS 13 in DARK mode
               [_resultText setBackgroundColor:[UIColor UITEXTBGDARK]];
               [_resultText setTextColor:[UIColor UITEXTDARK]];
               [_urlText setBackgroundColor:[UIColor UITEXTBGDARK]];
               [_urlText setTextColor:[UIColor UITEXTDARK]];
               // [self.view setBackgroundColor:[UIColor colorWithRed:0.642038 green:0.802669 blue:0.999195 alpha:1.0]];
               [self.view setBackgroundColor:[UIColor UIDARKBACKGROUND]];
           }
           else {
               // iOS 13  in LIGHT mode

           }
       } else {
           // Fallback on earlier versions set above
    }
    
    // timings
    _timings.text = @"NS: ----   TCP: ----    SSL: ----    FB: ----    Total: ----";
    
    // CERTS
    /*
    NSString *destPathCA = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPathCA = [destPathCA stringByAppendingPathComponent:@"cacert.pem"];
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManagerCA = [NSFileManager defaultManager];
    if (![fileManagerCA fileExistsAtPath:destPathCA]) {
        //NSLog(@"Creating URL Favorites Plist in Document Store");
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"cacert" ofType:@"pem"];
        success = [fileManagerCA copyItemAtPath:sourcePath toPath:destPathCA error:&error];
        if(!success)
            NSLog(@"Failed to copy cacert.pem [from %@ to %@] (%@)",sourcePath, destPathCA, error);
    }
    */
    // HISTORY
    // urls.plist = Load URL history from plist
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"urls.plist"];
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:destPath]) {
        //NSLog(@"Creating URL Favorites Plist in Document Store");
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"urls" ofType:@"plist"];
        success = [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        if(!success)
            NSLog(@"Failed to create urls.plist [from %@ to %@] (%@)",sourcePath, destPath, error);
    }
    favoriteURLs = [[NSMutableArray alloc] initWithContentsOfFile:destPath];
    //NSLog(@"Loading from %@ - favoriteURLs: %@",destPath, favoriteURLs);
    
    // urlspost.plist = Load POST Data for favorites
    NSString *destPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath2 = [destPath2 stringByAppendingPathComponent:@"urlspost.plist"];
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager2 = [NSFileManager defaultManager];
    if (![fileManager2 fileExistsAtPath:destPath2]) {
        //NSLog(@"Creating URL Favorites POST in Document Store");
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"urlspost" ofType:@"plist"];
        success = [fileManager2 copyItemAtPath:sourcePath toPath:destPath2 error:&error];
        if(!success)
            NSLog(@"Failed to create urlspost.plist [from %@ to %@] (%@)",sourcePath, destPath2, error);
    }
    favoritePOST = [[NSMutableArray alloc] initWithContentsOfFile:destPath2];
    //NSLog(@"Loading from %@ - favoritePOST: %@",destPath2, favoritePOST);
    
    // urlsheader.plist = Load HEADER Data for favorites
    NSString *destPath3 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath3 = [destPath3 stringByAppendingPathComponent:@"urlsheader.plist"];
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager3 = [NSFileManager defaultManager];
    if (![fileManager3 fileExistsAtPath:destPath3]) {
        //NSLog(@"Creating URL Favorites POST in Document Store");
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"urlsheader" ofType:@"plist"];
        success = [fileManager3 copyItemAtPath:sourcePath toPath:destPath3 error:&error];
        if(!success)
            NSLog(@"Failed to create urlsheader.plist [from %@ to %@] (%@)",sourcePath, destPath3, error);
    }
    favoriteHEADER = [[NSMutableArray alloc] initWithContentsOfFile:destPath3];
    //NSLog(@"Loading from %@ - favoriteHEADER: %@",destPath3, favoriteHEADER);
    
    // Load iCurlHTTP User Settings
    [self loadSettings];
    
    // create ActionSheet for popup when Share is pressed
    // TO DO:  Need to convert to UIAlertControllerStyleActionSheet
    /*
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Print", @"Email", @"Copy", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    */
    // We want to be notified when the keyboard appears so we can resize the tableview URL history dropdown
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// remember contentInset value
UIEdgeInsets insetDefault;

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    int spacer;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if(kbSize.height < kbSize.width) spacer = kbSize.height;
    else spacer = kbSize.width;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, spacer, 0.0);
    // dropdown table for URL history
    if(_urlDropdown.hidden==NO) {
            insetDefault = _urlDropdown.contentInset;
            //NSLog(@"_urlDropdown: Keyboard up - kbsize = %f",kbSize.height);
        _urlDropdown.contentInset = contentInsets;
        _urlDropdown.scrollIndicatorInsets = contentInsets;
    }
    //NSLog(@"Keyboard Shown* ");
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    //UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentInsets = insetDefault;
    _urlDropdown.contentInset = contentInsets;
    _urlDropdown.scrollIndicatorInsets = contentInsets;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Support for iOS 13 and Dark Mode
    if (@available(iOS 13.0, *)) {
        // Dark Mode On
           if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
               // iOS 13 in DARK mode
               [_resultText setBackgroundColor:[UIColor UITEXTBGDARK]];
               if(globalReset > 0) [_resultText setTextColor:[UIColor UITEXTDARKBUSY]];
               else [_resultText setTextColor:[UIColor UITEXTDARK]];
               [_urlText setBackgroundColor:[UIColor UITEXTBGDARK]];
               [_urlText setTextColor:[UIColor UITEXTDARK]];
               [self.view setBackgroundColor:[UIColor UIDARKBACKGROUND3]];
               //[_httpReq setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:12]} forState:UIControlStateHighlighted];
           }
           else {
               // iOS 13  in LIGHT mode
               [_resultText setBackgroundColor:[UIColor UITEXTBGLIGHT]];
               if(globalReset > 0) [_resultText setTextColor:[UIColor UITEXTLIGHTBUSY]];
               else [_resultText setTextColor:[UIColor UITEXTLIGHT]];
               [_urlText setBackgroundColor:[UIColor UITEXTBGLIGHT]];
               [_urlText setTextColor:[UIColor UITEXTLIGHT]];
               [self.view setBackgroundColor:[UIColor UILIGHTBACKGROUND]];
           }
       } else {
           // Fallback on earlier versions set above
    }
}
// remember contentInset value
//UIEdgeInsets insetRotate;

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    // A rotation or resize occured
    /*
    if ((int)[[UIScreen mainScreen] nativeBounds].size.height == 2436) {
        // iPhone X
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationPortrait:
                NSLog(@"Rotate: Portrait");
                // remove indents
                break;
            case UIDeviceOrientationLandscapeLeft:
                // indent left
                //insetRotate = view.contentInset;
                NSLog(@"Rotate: Left");
                break;
            case UIDeviceOrientationLandscapeRight:
                // ident right
                NSLog(@"Rotate: Right");
                break;
            default:
                break;
        }
    }
     */
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    // regen the table data if exposed
    [_urlDropdown reloadData];
}

/*
//
// ALERT Large File
//
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    waitForUser = FALSE; // unblock thread
    
    if ([alertView tag] == 12) {    // Large File Alert
        // if largefileAlert is fired - catch cancel button to stop download
        if (buttonIndex == 0) {
            // flag for download cancelation
            globalReset = 2;
        }

    }
    if ([alertView tag] == 55) {    // Error
        if (buttonIndex == 0) {
            // OK pushed - dismiss
        }
    }
    //if (buttonIndex == 0) {
    //    // flag for download cancelation
    //    globalReset = 2;
    //}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if ([alertView tag] == 14) {    // Follow Redirect
        //NSLog(@"buttonIndex=%ld",(long)buttonIndex);
        if (buttonIndex == 1) {
            // set 301/302 URL and follow
            _urlText.text = [NSString stringWithFormat:@"%@",redirect_url];
            [self Go:(self)]; // force Go action method to load URL
        }
    }
}
*/

//
// ACTIONSHEET methods (Share button)
//

- (void) sharePrint
{
    // date
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE d MMM yyyy, h:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    // @"The Current Time is %@",[dateFormatter stringFromDate:now]
    
    // data to send
    NSString *copyString = [[NSString alloc] initWithFormat:@"%@\n\nURL: %@\nDate: %@\n\n%@\n\n",
                            [@"iCurlHTTP v" stringByAppendingFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]],_urlText.text,[dateFormatter stringFromDate:now],_resultText.text];
    // PRINT
    //NSLog(@"0 - Print");
    
    //if(![UIPrintInteractionController isPrintingAvailable]) {
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    pic.delegate = self;
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = self.title;
    pic.printInfo = printInfo;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:copyString];
    textFormatter.startPage = 0;
    textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0); // 1 inch margins
    textFormatter.maximumContentHeight = 8.5 * 72.0;
    pic.printFormatter = textFormatter;
    pic.showsPageRange = YES;
    
    void(^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error) {
            NSLog(@"Printing Error: %@", error);
        }
    };
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {

        //NSLog(@"iPad print");
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenRect.origin.y = 0;
        screenRect.origin.x = 0;
        // try to find something close to the center but works during rotation
        if(screenRect.size.width > screenRect.size.height) {
            screenRect.size.width = screenRect.size.height;
            screenRect.size.height = screenRect.size.height/2;
        } else {
            screenRect.size.height = screenRect.size.width/2;
            //screenRect.size.width = screenRect.size.width;
        }

        [pic presentFromRect:screenRect inView:self.view animated:YES completionHandler:completionHandler];
        
    }
    else {
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
    
    //}
}

- (void)shareEmail
{
    // date
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE d MMM yyyy, h:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    // @"The Current Time is %@",[dateFormatter stringFromDate:now]
    
    // data to send
    NSString *copyString = [[NSString alloc] initWithFormat:@"%@\n\nURL: %@\nDate: %@\n\n%@\n\n",
                            [@"iCurlHTTP v" stringByAppendingFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]],_urlText.text,[dateFormatter stringFromDate:now],_resultText.text];

    //NSLog(@"1 - Email");
    // EMAIL
    if ([MFMailComposeViewController canSendMail]) {
        //NSLog(@"I can send email!!");
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[@"iCurlHTTP: " stringByAppendingFormat:@"%@",_urlText.text]];
        
        //NSArray *toRecipients = [NSArray arrayWithObjects:nil];
        //[mailer setToRecipients:toRecipients];
        NSString *emailBody = copyString;
        [mailer setMessageBody:emailBody isHTML:NO];
        // for iPad - provide nicer interface
        if (!([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
            mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        }
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertController *myAlertControllera = [UIAlertController
                                                alertControllerWithTitle:@"Unable to Email"
                                                message:@"Email is not configured for your device."
                                                preferredStyle:UIAlertControllerStyleAlert                   ];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [myAlertControllera dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [myAlertControllera addAction: ok];
        [self presentViewController:myAlertControllera animated:YES completion:nil];

        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Email"
                                                        message:@"Email is not configured for your device."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert setTag:55];
        [alert show];
        */
    }

}

- (void) shareCopy
{
    // copy to clipboard
    // date
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEEE d MMM yyyy, h:mm a";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    // @"The Current Time is %@",[dateFormatter stringFromDate:now]
    
    // data to send
    NSString *copyString = [[NSString alloc] initWithFormat:@"%@\n\nURL: %@\nDate: %@\n\n%@\n\n",
                            [@"iCurlHTTP v" stringByAppendingFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]],_urlText.text,[dateFormatter stringFromDate:now],_resultText.text];
    // COPY
    // clipboard for copy/paste
    //NSLog(@"2 - Copy\n%@",copyString);
    UIPasteboard *clipboard = [UIPasteboard generalPasteboard];
    [clipboard setString:copyString];
}

/*  Deprecated in iOS 8
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // call action based on button pressed
    if(buttonIndex==0) {
        [self sharePrint];
    }
    if(buttonIndex==1) {
        [self shareEmail];
    }
    if(buttonIndex==2) {
        [self shareCopy];
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    //NSLog(@"actionSheetCancel - system canceled action sheet");
}
*/

// Mail System
//
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            //NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            //NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            //NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

//
// User changed http verb
//
- (IBAction)ReqType:(id)sender
{
    
    // Check for an existing thread - we can't render parallel curls
    if(globalReset > 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_resultText setTextColor:[UIColor redColor]]; // notify users that existing curl is terminated
        globalReset = 2; // set global flag that a cancellation is requested to let curl functions to know to terminate
        return;
    }
    
    // inform user to press go - allowing them to make other changes
    // Support for iOS 13 and Dark Mode - text to gray to indicate curl is loading
    if (@available(iOS 13.0, *)) {
        // Dark Mode On
           if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
               // iOS 13 in DARK mode
               [_resultText setBackgroundColor:[UIColor UIBGWAITDARK]];
               [_resultText setTextColor:[UIColor UITEXTDARK]];
           }
           else {
               // iOS 13  in LIGHT mode
               [_resultText setBackgroundColor:[UIColor UIBGWAITLIGHT]];
               [_resultText setTextColor:[UIColor UITEXTLIGHT]];
           }
       } else {
           // Fallback on earlier versions set above
           [_resultText setBackgroundColor:[UIColor UIBGWAITLIGHT]];
           [_resultText setTextColor:[UIColor UITEXTLIGHT]];
    }
    //[_resultText setBackgroundColor:[UIColor grayColor]];
    //[_resultText setTextColor:[UIColor blackColor]];
    
    _resultText.text = @"\n\n\n⊣ Select options or tap Go to Continue ⊢";
    _resultText.textAlignment = NSTextAlignmentCenter;
    
}

- (void)runGo:(NSTimer *)timer
{
    // run Go
    [self Go:(self)];
}
    
//
//
// GO ACTION - Recieved UI request to run curl
//
//
- (IBAction)Go:(id)sender
{
    BOOL success; // response placeholder
    
    // start activity spinner
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.color = [UIColor darkGrayColor];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // update curl timeout value to userTimeout settings
    if(userTimeout.integerValue>0) curl_easy_setopt(_curl, CURLOPT_TIMEOUT, [userTimeout longValue]); // seconds
    if(userConnectTimeout.integerValue>0) curl_easy_setopt(_curl, CURLOPT_CONNECTTIMEOUT, [userConnectTimeout longValue]); // seconds
    
    [_urlText resignFirstResponder]; // remove keyboard
    _urlDropdown.hidden=YES; // hide dropdown
    
    // Support for iOS 13 and Dark Mode - text to gray to indicate curl is loading
    if (@available(iOS 13.0, *)) {
        // Dark Mode On
           if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
               // iOS 13 in DARK mode
               [_resultText setBackgroundColor:[UIColor UITEXTBGDARK]];
               [_resultText setTextColor:[UIColor UITEXTDARKBUSY]];
           }
           else {
               // iOS 13  in LIGHT mode
               [_resultText setBackgroundColor:[UIColor UITEXTBGLIGHT]];
               [_resultText setTextColor:[UIColor UITEXTLIGHTBUSY]];
           }
       } else {
           // Fallback on earlier versions set above
           [_resultText setBackgroundColor:[UIColor UITEXTBGLIGHT]];
           [_resultText setTextColor:[UIColor UITEXTLIGHTBUSY]];
    }
    
    // Check for an existing thread - we can't render parallel curls
    if(globalReset > 0) {
        [activityView stopAnimating]; // shutdown spinner
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_resultText setTextColor:[UIColor redColor]]; // notify users that existing curl is terminated
        // NSLog(@"Go action recived while download still in progress, aborting.");
        globalReset = 2; // set global flag that a cancellation is requested to let curl functions to know to terminate
        return;
    }
    
    // Update interface for new curl
    _progress.hidden = NO;
    _resultText.text = @""; // clear viewer
    _resultText.textAlignment = NSTextAlignmentLeft;
    _timings.text = @"NS: ----   TCP: ----    SSL: ----    FB: ----    Total: ----"; // clear timings
    _timings.hidden=NO; // unhide timing data
    globalReset = 1; //  global flag set - indicate that a thread to download URL is in progress
    _progress.progress = 0.0; // start progress bar at zero
    //[_resultText setTextColor:[UIColor grayColor]]; // text to gray to indicate curl loading
    largefileAlert = FALSE;
    waitForUser = FALSE;
    //autoRedirect = FALSE;
    downloadedSize = 0;
    fileSize = 0;
    
    // Give some render time to show response before we hit the network
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    
    // Address resolution support
    if(userIPv4 && !userIPv6) curl_easy_setopt(_curl, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V4);
    if(!userIPv4 && userIPv6) curl_easy_setopt(_curl, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_V6);
    if(userIPv4 == userIPv6) curl_easy_setopt(_curl, CURLOPT_IPRESOLVE, CURL_IPRESOLVE_WHATEVER);
    
    // DNS Resolve Override
    if(userResolve && ![userResolve isEqual: @""]) {
        _resolvehost = curl_slist_append(_resolvehost, [userResolve UTF8String]);
        curl_easy_setopt(_curl, CURLOPT_RESOLVE, _resolvehost);
    }
    
    // Verify URL
    if (!_urlText.text || [_urlText.text isEqualToString:@""]) {
        if([favoriteURLs objectAtIndex:0] && ![[favoriteURLs objectAtIndex:0] isEqualToString:@""])
        {
            _urlText.text = [favoriteURLs objectAtIndex:0];
            // POST request?
            if(_httpReq.selectedSegmentIndex == 2L && [favoritePOST objectAtIndex:0] && ![[favoritePOST objectAtIndex:0] isEqualToString:userPost]) {
                    // Post data is included in the history
                    userPost = [favoritePOST objectAtIndex:0];
                    [self saveSettings]; // save settings Plist
            }
            if([favoriteHEADER objectAtIndex:0] && ![[favoriteHEADER objectAtIndex:0] isEqualToString:userHeaders]) {
                    // Header info is included in the history
                userHeaders = [favoriteHEADER objectAtIndex:0];
                [self saveSettings]; // save settings Plist
            }
        }
        else _urlText.text = @"http://www.apple.com";  // no address provided, fill in default
    }
    
    if([_urlText.text length] > 6) if([[_urlText.text substringToIndex:6] isEqualToString:@"https:" ]) { // https
        if(userInsecure && _verbose.selectedSegmentIndex == 1L) _resultText.text = [ _resultText.text stringByAppendingString:@"-- HTTPS: SSL Verification Disabled\n"];
        if(userSSLv3) {
            curl_easy_setopt(_curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_SSLv3); // SSLv3 protocol
            if(_verbose.selectedSegmentIndex == 1L) _resultText.text = [_resultText.text stringByAppendingString:@"-- HTTPS: Force SSLv3 Protocol\n"];
        }
        else curl_easy_setopt(_curl, CURLOPT_SSLVERSION, CURL_SSLVERSION_DEFAULT); // TLSv1 protocol - Default
    }
    
    // Add new URL to favorites
    NSString *urlToAdd = _urlText.text;
    NSString *postToAdd = userPost;
    NSString *headerToAdd = userHeaders;
    if (
        //([[favoritePOST objectAtIndex:0] isEqualToString:(NSString *)postToAdd]) &&
        ([[favoriteURLs   objectAtIndex:0] isEqualToString:(NSString *)urlToAdd]   ) &&
        ([[favoriteHEADER objectAtIndex:0] isEqualToString:(NSString *)headerToAdd]) &&
        (   (_httpReq.selectedSegmentIndex == 2L && [[favoritePOST objectAtIndex:0] isEqualToString:(NSString *)postToAdd]) ||
            (_httpReq.selectedSegmentIndex != 2L && (![favoritePOST objectAtIndex:0] || [[favoritePOST objectAtIndex:0] isEqualToString:@""])) )
        ) {
        //NSLog(@"Favorites - Do Nothing %@\n%@\n%@",urlToAdd,postToAdd,[favoriteURLs objectAtIndex:0]);
        // don't add anything if recent URL is the same as top of favorites
    } else {
        // New url to add to history favorites
        [favoriteURLs insertObject:(urlToAdd) atIndex:(0) ];
        if(_httpReq.selectedSegmentIndex == 2L) [favoritePOST insertObject:(postToAdd) atIndex:(0) ];
        else [favoritePOST insertObject:(@"") atIndex:(0)];
        [favoriteHEADER insertObject:(headerToAdd) atIndex:0];
        if ([favoriteURLs count] > 30) { // trim after 30 urls
            [favoriteURLs removeLastObject];
        }
        if ([favoritePOST count] > 30) { // trim after 30 urls
            [favoritePOST removeLastObject];
        }
        if ([favoriteHEADER count] > 30) { // trim after 30 urls
            [favoriteHEADER removeLastObject];
        }
        // NSLog(@"favoriteURLs: %@",favoriteURLs);
        [_urlDropdown reloadData]; // reload tableview data
        
        // Save favorites to urls.plist
        NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        destPath = [destPath stringByAppendingPathComponent:@"urls.plist"];
        success  = [favoriteURLs writeToFile:destPath atomically:YES];
        if (!success) NSLog(@"Failed to write to url.plist: %@",destPath);
        // Saving POST data to urlspost.plist
        NSString *destPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        destPath2 = [destPath2 stringByAppendingPathComponent:@"urlspost.plist"];
        success  = [favoritePOST writeToFile:destPath2 atomically:YES];
        if (!success) NSLog(@"Failed to write to urlpost.plist: %@",destPath2);
        // Saving HEADER data to urlsheader.plist
        NSString *destPath3 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        destPath3 = [destPath3 stringByAppendingPathComponent:@"urlsheader.plist"];
        success  = [favoriteHEADER writeToFile:destPath3 atomically:YES];
        if (!success) NSLog(@"Failed to write to urlheader.plist: %@",destPath3);
    }
    
    if (_urlText.text && ![_urlText.text isEqualToString:@""]) {    
        CURLcode theResult;
		NSURL *url = [NSURL URLWithString:_urlText.text];
		NSString *proxyHost = @"";
		NSNumber *proxyPort = @0L;
		NSDictionary *proxySettings = (__bridge_transfer NSDictionary *)CFNetworkCopySystemProxySettings();
		
		if (_headers) {
			curl_slist_free_all(_headers);
			_headers = NULL;
		}
		//[_dataReceived setLength:0U];  // clear buffer
		_dataToSendBookmark = 0U;
		
        // set URL - warning: curl_easy_setopt() doesn't retain the memory passed into it
		curl_easy_setopt(_curl, CURLOPT_URL, url.absoluteString.UTF8String);

        // set up browser emulation - helpful reference: https://www.whatismybrowser.com/guides/the-latest-user-agent/
        switch (_browserType.selectedSegmentIndex) {
            case 0L: default:
                // iCurlHTTP
                curl_easy_setopt(_curl, CURLOPT_USERAGENT, [userAgent UTF8String] );
                break;
            case 1L:
                // Safari (iPhone) - Safari on iOS
                curl_easy_setopt(_curl, CURLOPT_USERAGENT,
                    "Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1");
                break;
            case 2L:
                // Safari (iPad) - Safari on iOS
                curl_easy_setopt(_curl, CURLOPT_USERAGENT,
                    "Mozilla/5.0 (iPad; CPU OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Mobile/15E148 Safari/604.1");
                break;
            case 3L:
                // Safari (Mac) - Safari on MacOS
                curl_easy_setopt(_curl, CURLOPT_USERAGENT,
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15");
                break;
            case 4L:
                // Edge (PC) - Edge on Windows 10/11
                curl_easy_setopt(_curl, CURLOPT_USERAGENT,
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36 Edg/100.0.1185.39");
                break;
            case 5L:
                // Chrome (MAC) - Chrome on MacOS
                curl_easy_setopt(_curl, CURLOPT_USERAGENT,
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.63 Safari/537.36");
                break;
            case 6L:
                // Firefox (PC) - only on iPad
                curl_easy_setopt(_curl, CURLOPT_USERAGENT,
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101 Firefox/100.0");
                break;
        }
        
		// Set up proxies
		if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPEnable] && [[proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPEnable] boolValue])
		{
			if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPProxy])
				proxyHost = [proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPProxy];
			if ([proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPPort])
				proxyPort = [proxySettings objectForKey:(NSString *)kCFNetworkProxiesHTTPPort];
		}
		curl_easy_setopt(_curl, CURLOPT_PROXY, proxyHost.UTF8String);
		curl_easy_setopt(_curl, CURLOPT_PROXYPORT, proxyPort.longValue);
		
        // HTTP verb
		curl_easy_setopt(_curl, CURLOPT_UPLOAD, 0L);
        curl_easy_setopt(_curl, CURLOPT_HTTPHEADER, NULL);
        
        // HTTP2
        if(userHTTP2) {
            curl_easy_setopt(_curl, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_2_0);
        }
        else curl_easy_setopt(_curl, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
        
        // HTTP Headers
        NSArray *myHeaders = [userHeaders componentsSeparatedByString:@"\n"];
        //NSLog(@"myHeaders=%@",myHeaders);
        for (id object in myHeaders) {
            //NSLog(@"header=%@",object);
            if([object length] > 1) _headers = curl_slist_append(_headers, [object UTF8String]);
        }
        //httpheaders = curl_slist_append(httpheaders, "Transfer-Encoding: chunked");
        //curl_easy_setopt(_curl, CURLOPT_HTTPHEADER, chunk);
        /* use curl_slist_free_all() after the *perform() call to free this
         list again */
        
		if(userHeaders) {
            curl_easy_setopt(_curl, CURLOPT_HTTPHEADER, _headers );
        } else {
            curl_easy_setopt(_curl, CURLOPT_HTTPHEADER, NULL);
        }
		switch (_httpReq.selectedSegmentIndex) {
			case 0L: default:
                // GET
                ///NSLog(@"--GET--");
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,nil);
				curl_easy_setopt(_curl, CURLOPT_HTTPGET, 1L);
				break;
			case 1L:
                // HEAD
                //NSLog(@"--HEAD--");
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,nil);
				curl_easy_setopt(_curl, CURLOPT_NOBODY, 1L);
				break;
            case 2L:
                // POST
                curl_easy_setopt(_curl, CURLOPT_NOBODY, 0L);
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,nil);
                curl_easy_setopt(_curl, CURLOPT_POSTFIELDS, [userPost UTF8String]);
                break;
            case 3L:
                // PUT
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,nil);
                //curl_easy_setopt(_curl, CURLOPT_PUT, 1L);
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,"PUT");
                curl_easy_setopt(_curl, CURLOPT_POSTFIELDS, [userPost UTF8String]);
                break;
            case 4L:
                // DELETE
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,"DELETE");
                // !!!!! TO DO: may needs user/pass 
                break;
            case 5L:
                // TRACE
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,"TRACE");
                break;
            case 6L:
                // OPTIONS
                curl_easy_setopt(_curl,CURLOPT_CUSTOMREQUEST,"OPTIONS");
                break;
        }
		// Enforce new connections each time instead of connection sharing
        curl_easy_setopt(_curl, CURLOPT_FORBID_REUSE, 1L);
        
        // HTTP Authentication
        if(userName.length>0 || userPass.length>0) {
            // don't set this unless user or pass specified in setting - otherwise default to URL user:pass@
            curl_easy_setopt(_curl,CURLOPT_USERNAME,[userName UTF8String]);
            curl_easy_setopt(_curl,CURLOPT_PASSWORD,[userPass UTF8String]);
        }
        // Set HTTP Auth mode - user/pass may be in URL
            //#define CURLAUTH_NONE         ((unsigned long)0)
            //#define CURLAUTH_BASIC        (((unsigned long)1)<<0)
            //#define CURLAUTH_DIGEST       (((unsigned long)1)<<1)
            //#define CURLAUTH_GSSNEGOTIATE (((unsigned long)1)<<2)
            //#define CURLAUTH_NTLM         (((unsigned long)1)<<3)
            //#define CURLAUTH_DIGEST_IE    (((unsigned long)1)<<4)
            //#define CURLAUTH_NTLM_WB      (((unsigned long)1)<<5)
            //#define CURLAUTH_ONLY         (((unsigned long)1)<<31)
            //#define CURLAUTH_ANY          (~CURLAUTH_DIGEST_IE)
        int authtype=0;
        if(userAuthAny) authtype += CURLAUTH_ANY;
        if(userAuthBasic) authtype += CURLAUTH_BASIC;
        if(userAuthDigest) authtype += CURLAUTH_DIGEST;
        if(userAuthNegotiate) authtype += CURLAUTH_GSSNEGOTIATE;
        if(userAuthNTLM) authtype += CURLAUTH_NTLM;
        curl_easy_setopt(_curl,CURLOPT_HTTPAUTH, authtype);
        //NSLog(@":::Auth %d:::",authtype);

        
		// SSL Verification - Disable by Default
        curl_easy_setopt(_curl, CURLOPT_SSL_VERIFYHOST, userInsecure ? 0L : 2L); // 2L to verify, 0L to disable
        curl_easy_setopt(_curl, CURLOPT_SSL_VERIFYPEER, userInsecure ? 0L : 1L); // 1L to verify, 0L to disable
            
        // PERFORM the Curl
        // _progress.progress = 0.01; // update progress bar to show start
		theResult = curl_easy_perform(_curl);
		if (theResult == CURLE_OK) {
            long http_code, http_ver;
            double total_time, total_size, total_speed, timing_ns, timing_tcp, timing_ssl, timing_fb;
            char *redirect_url2 = NULL;
            curl_easy_getinfo(_curl, CURLINFO_RESPONSE_CODE, &http_code);
            curl_easy_getinfo(_curl, CURLINFO_TOTAL_TIME, &total_time);
            curl_easy_getinfo(_curl, CURLINFO_SIZE_DOWNLOAD, &total_size);
            curl_easy_getinfo(_curl, CURLINFO_SPEED_DOWNLOAD, &total_speed); // total
            curl_easy_getinfo(_curl, CURLINFO_APPCONNECT_TIME, &timing_ssl); // ssl handshake time
            curl_easy_getinfo(_curl, CURLINFO_CONNECT_TIME, &timing_tcp); // tcp connect
            curl_easy_getinfo(_curl, CURLINFO_NAMELOOKUP_TIME, &timing_ns); // name server lookup
            curl_easy_getinfo(_curl, CURLINFO_STARTTRANSFER_TIME, &timing_fb); // firstbyte
            curl_easy_getinfo(_curl, CURLINFO_REDIRECT_URL, &redirect_url2); // redirect URL
            curl_easy_getinfo(_curl, CURLINFO_HTTP_VERSION, &http_ver); // HTTP protocol
            
            NSString *http_ver_s, *http_h=@"";
            if(http_ver == CURL_HTTP_VERSION_1_0) {
                http_ver_s = @"HTTP/1.0";
                http_h = @"H/1.0";
                //NSLog(@"HTTP/1.0");
            }
            if(http_ver == CURL_HTTP_VERSION_1_1) {
                http_ver_s = @"HTTP/1.1";
                http_h = @"H/1.1";
                //NSLog(@"HTTP/1.1");
            }
            if(http_ver == CURL_HTTP_VERSION_2_0) {
                http_ver_s = @"HTTP/2";
                http_h = @"H/2";
                //NSLog(@"HTTP/2.0");
            }

            redirect_url = [NSString stringWithFormat:@"%s",redirect_url2];
            //NSLog(@"REDIRECT!!!%@\n",redirect_url);
            // timings
            if(timing_ssl>0.0f) {
                _timings.text = [@"" stringByAppendingFormat:@"NS: %0.1fs   TCP: %0.1fs    SSL: %0.1fs    FB: %0.1fs    Total: %0.1fs   %@",timing_ns,timing_tcp,timing_ssl,timing_fb,total_time,http_h ];
            } else {
                _timings.text = [@"" stringByAppendingFormat:@"NS: %0.1fs   TCP: %0.1fs    SSL: ----    FB: %0.1fs    Total: %0.1fs   %@",timing_ns,timing_tcp,timing_fb,total_time,http_h ];
            }
            // verbose detials in viewer
   			if(_verbose.selectedSegmentIndex == 1L) { // verbose/detail requested by user
                if(timing_ssl>0.0f) {
                    /* // This puts summary details at top
                    _resultText.text = [NSString stringWithFormat:@"\n** Timing Details **\n-- \tName Lookup:\t%0.2fs\n-- \tTCP Connect: \t%0.2fs\n-- \tSSL Handshake: \t%0.2fs\n-- \tFirst Byte: \t\t%0.2fs\n-- \tTotal Download: \t%0.2fs\n-- Size: %0.0f bytes\n-- Speed: %0.0f bytes/sec\n-- Using: %@\n** RESULT CODE: %ld**\n\n** Response **\n%@",
                                        timing_ns,timing_tcp,timing_ssl,timing_fb,
                                        total_time,total_size, total_speed, http_ver_s, http_code,_resultText.text];
                    */
                    // This puts summary details at the end
                    _resultText.text = [_resultText.text stringByAppendingFormat:@"\n** Timing Details **\n-- \tName Lookup:\t%0.2fs\n-- \tTCP Connect: \t%0.2fs\n-- \tSSL Handshake: \t%0.2fs\n-- \tFirst Byte: \t\t%0.2fs\n-- \tTotal Download: \t%0.2fs\n-- Size: %0.0f bytes\n-- Speed: %0.0f bytes/sec\n-- Using: %@\n** RESULT CODE: %ld**",
                                        timing_ns,timing_tcp,timing_ssl,timing_fb,
                                        total_time,total_size, total_speed, http_ver_s, http_code];
                    //             @{FXFormFieldKey: @"userCertDetail", FXFormFieldTitle: @"Verbose Cert Details", FXFormFieldType: FXFormFieldTypeOption},
                    
                    if(userCertDetail) {
                        // Show Addtional Certificate Details if Requested
                        // Details here: https://curl.haxx.se/libcurl/c/certinfo.html
                        _resultText.text = [_resultText.text stringByAppendingFormat:@"\n\n** Certificate Chain Details **\n"];
                        
                        union {
                            struct curl_slist    *to_info;
                            struct curl_certinfo *to_certinfo;
                        } ptr;
                        
                        ptr.to_info = NULL;
                        
                        if(!curl_easy_getinfo(_curl, CURLINFO_CERTINFO, &ptr.to_info)) {
                            
                            if(ptr.to_info) {
                                int i;
                                
                                //printf("%d certs!\n", ptr.to_certinfo->num_of_certs);
                                _resultText.text = [_resultText.text stringByAppendingFormat:@"\n-- Number of Certs: %d", ptr.to_certinfo->num_of_certs];
                                
                                for(i = 0; i < ptr.to_certinfo->num_of_certs; i++) {
                                    struct curl_slist *slist;
                                    
                                    for(slist = ptr.to_certinfo->certinfo[i]; slist; slist = slist->next) {
                                        // printf("%s\n", slist->data);
                                        _resultText.text = [_resultText.text stringByAppendingFormat:@"\n---\n%s", slist->data];
                                    }
                                    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                                }
                            }
                        }
                    }
                    
                } else {
                    _resultText.text = [_resultText.text stringByAppendingFormat:@"\n** Timing Details **\n-- \tName Lookup:\t%0.2fs\n-- \tTCP Connect: \t%0.2fs\n-- \tFirst Byte: \t\t%0.2fs\n-- \tTotal Download: \t%0.2fs\n-- Size: %0.0f bytes\n-- Speed: %0.0f bytes/sec\n-- Using: %@\n** RESULT CODE: %ld**",
                                        timing_ns,timing_tcp,timing_fb, 
                                        total_time,total_size, total_speed, http_ver_s, http_code];
                }

            }
            
            _progress.progress = 1.0; // update progress bar to done
            
            // update text to full brightness to indicate completed
            if (@available(iOS 13.0, *)) {
                // Dark Mode On
                   if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                       // iOS 13 in DARK mode
                       [_resultText setTextColor:[UIColor UITEXTDARK]];
                   }
                   else {
                       // iOS 13  in LIGHT mode
                       [_resultText setTextColor:[UIColor UITEXTLIGHT]];
                   }
               } else {
                   // Fallback on earlier versions
                   [_resultText setTextColor:[UIColor UITEXTLIGHT]];
            }
            
            // REDIRECT DETECTED?
            if(http_code==301 || http_code==302) {
                const int clipLength = 200;
                //NSLog(@"Len=%ld",[redirect_url length]);
                NSString *redirectcopy;
                if([redirect_url length]>clipLength)
                {
                    redirectcopy = [NSString stringWithFormat:@"%@...%@",[redirect_url substringToIndex:(clipLength/2)], [redirect_url substringFromIndex:([redirect_url length]-(clipLength/2))]];
                }
                else redirectcopy = [redirect_url copy];
                waitForUser = TRUE;
                // follow redirect?  Alert Controller

                UIAlertController *myAlertControllerb = [UIAlertController
                                                        alertControllerWithTitle:[NSString stringWithFormat:@"%ld Redirect",http_code]
                                                        message: [NSString stringWithFormat:@"%@\n\nDo you wish to follow redirect?",redirectcopy]
                                                        preferredStyle:UIAlertControllerStyleAlert                   ];
                
                // Create a UIAlertAction that can be added to the alert
                UIAlertAction* yes = [UIAlertAction
                                      actionWithTitle:@"Yes"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          // set 301/302 URL and follow
                                          self->_urlText.text = [NSString stringWithFormat:@"%@",self->redirect_url];
                                          //autoRedirect = TRUE;
                                          waitForUser = FALSE;
                                          [myAlertControllerb dismissViewControllerAnimated:YES completion:nil];
                                          // launch a 1s Timer to run Go after UIAlertAction dismisses
                                          [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                           target:self
                                                                         selector:@selector(runGo:)
                                                                         userInfo:nil
                                                                          repeats:NO];
                                          //[self Go:(self)]; // Memory Leak & Hang Bug
                                          
                                      }];
                UIAlertAction* no = [UIAlertAction
                                      actionWithTitle:@"No"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          waitForUser = FALSE;
                                          // dismiss the alertwindow
                                          [myAlertControllerb dismissViewControllerAnimated:YES completion:nil];
                                          
                                      }];
                
                // Add the UIAlertAction ok that we just created to our AlertController
                [myAlertControllerb addAction: no];
                [myAlertControllerb addAction: yes];
                
                // Present the alert to the user
                [self presentViewController:myAlertControllerb animated:YES completion:nil];
                /*
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%ld Redirect",http_code]
                                                                message:[NSString stringWithFormat:@"%@\n\nDo you wish to follow redirect?",redirectcopy]
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles: nil];
                //alert.alertViewStyle = UIAlertViewStylePlainTextInput; // add text input
                [alert setTag:14];
                [alert addButtonWithTitle:@"Yes"];
                [alert show];
                */
            }

		}
        else {
			_resultText.text = [_resultText.text stringByAppendingFormat:@"\n** TRANSFER INTERRUPTED - ERROR [%d]\n", theResult];
                [_resultText setTextColor:[UIColor UITEXTERROR]];
            if (theResult == 6) {
                _resultText.text = [_resultText.text stringByAppendingString:@"\n** Host Not Found - Check URL or Network\n"];

            }
            if (theResult == 28) {
                _resultText.text = [_resultText.text stringByAppendingFormat:@"** %@s TIMEOUT REACHED - Increase value in user settings.\n",userTimeout];
                UIAlertController *myAlertControllerc = [UIAlertController
                                                        alertControllerWithTitle:[NSString stringWithFormat:@"Aborted: %@s Timeout Reached",userTimeout]
                                                        message:[NSString stringWithFormat:@"Increase value in user settings."]
                                                        preferredStyle:UIAlertControllerStyleAlert                   ];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [myAlertControllerc dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [myAlertControllerc addAction: ok];
                [self presentViewController:myAlertControllerc animated:YES completion:nil];
                /*
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Aborted: %@s Timeout Reached",userTimeout]
                                                                message:[NSString stringWithFormat:@"Increase value in user settings."]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                //alert.alertViewStyle = UIAlertViewStylePlainTextInput; // add text input
                [alert setTag:55];
                [alert show];
                 */
            }
            if (theResult == 35) {
                if(!userSSLv3) _resultText.text = [_resultText.text stringByAppendingFormat:@"** Possible TLSv1 Failure by Server - Try SSLv3 in user setting.\n"];
                else _resultText.text = [_resultText.text stringByAppendingFormat:@"** Possible SSLv3 Rejection by Server - Disable SSLv3 in user setting.\n"];
            }
            if (theResult == 60) {
                _resultText.text = [_resultText.text stringByAppendingFormat:@"** CERTIFICATE INVALID - Certificate cannot be authenticated with known CAs. Select Insecure mode in user settings to bypass.\n"];
            }
            NSLog(@"** CURL ERROR %d **", theResult);
        }
        globalReset = 0;
        
        // clean up header linked list
        if (_headers) {
            curl_slist_free_all(_headers);
            _headers = NULL;
        }
        
    } else {
        NSLog(@"ERROR: Invalid _urlText passed.");
    }
    [activityView stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    _progress.hidden = YES;
    
    /*  RESET libcurl easy_init */
    if (_headers) curl_slist_free_all(_headers);
    if(_curl) curl_easy_cleanup(_curl);
    if (_resolvehost) curl_slist_free_all(_resolvehost);
    [self initLibcurl]; // reinitilize libcurl
    /*
    // If we presented a dialog, wait for user to decide
    if(waitForUser) NSLog(@"Go:waitForUser");
    while(waitForUser) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        NSLog(@"Go:waitForUser");
    }

    if(autoRedirect) [self Go:(self)]; // Did user want to redirect?  Call ourself.
*/
}

//
// Methods for URL dropdown
//
-(IBAction)DropDown:(id)sender{
    [_resultText setBackgroundColor:[UIColor grayColor]];
    _urlDropdown.hidden=NO; // activate dropdown
    _timings.hidden=YES; // hide timing label
    _progress.progress = 0.0; // clear progress bar
    _progress.hidden = YES;

}

//
// Share output text via printer, email, clipboard
//
-(IBAction)Share:(id)sender {
    _progress.progress = 0.0; // clear progress bar

    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    //NSLog(@"iOS Version %@\n",[versionCompatibility objectAtIndex:0]);
    if ([[versionCompatibility objectAtIndex:0] intValue] < 8) {
        // Version 7.x or earlier
        // use UIActionSheet
        // [actionSheet showInView:self.view];
        NSLog(@"ActionSheet only available in iOS 8+");
    } else {
        // NEW for Version 8 or later
        // Alert style
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        // Make choices for the user using alert actions.
        UIAlertAction *doCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //NSLog(@"doCancel");
        }];
        
        UIAlertAction *doPrint = [UIAlertAction actionWithTitle:@"Print" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //NSLog(@"doPrint");
            [self sharePrint];
        }];
        UIAlertAction *doEmail = [UIAlertAction actionWithTitle:@"Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //NSLog(@"doEmail");
            [self shareEmail];
        }];
        
        UIAlertAction *doCopy = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //NSLog(@"doCopy");
            [self shareCopy];
        }];
        
        // Add actions to the controller so they will appear
        [alert addAction:doPrint];
        [alert addAction:doEmail];
        [alert addAction:doCopy];
        [alert addAction:doCancel];
        
        // Finally present the action
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//
// User options - Custom User Settings
//
-(IBAction)User:(id)sender {
    _progress.progress = 0.0; // clear progress bar
    iCHSettingsViewController *settings = [[iCHSettingsViewController alloc] init];
    
    [self presentViewController:settings animated:YES completion:^{
        //NSLog(@"::User - Settings DONE::");
    }];
}

//
// User options - Reset Settings
//
-(IBAction)Reset:(id)sender {
    _progress.progress = 0.0; // clear progress bar
    
    //userAgent = [@"" stringByAppendingFormat:@"%s", curl_version()];
    userAgent = [@"" stringByAppendingFormat:@"iCurlHTTP/%@ %s", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], curl_version()];

    userName = @"";
    userPass = @"";
    
}

//
// Drop down URL History Table methods
//

// Answer TableView questions - how many sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Answer TableView questions - how many rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Make sure we send back the smallest array or it will crash the app
    NSInteger min = [favoriteURLs count];
    if([favoritePOST count] < min) min = [favoritePOST count];
    if([favoriteHEADER count] < min) min = [favoriteHEADER count];
    
    return min;
}

// Answer TableView questions - Cell height based on content
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(([favoritePOST objectAtIndex:indexPath.row] && ![[favoritePOST objectAtIndex:indexPath.row] isEqualToString:@""])
       && ([favoriteHEADER objectAtIndex:indexPath.row] && ![[favoriteHEADER objectAtIndex:indexPath.row] isEqualToString:@""])) {
        return 64;
    }
    else {
        return 44;
    }
}


// Answer TableView questions - Cell contents and customize the appearance
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        //cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByClipping;
    // Set up the cell ...
    cell.textLabel.text = [favoriteURLs objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"";
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.numberOfLines = 1;
    CGFloat trimWidth = cell.frame.size.width*0.75;
    // Do we add POST or HEADER details?
    if([favoritePOST objectAtIndex:indexPath.row] && ![[favoritePOST objectAtIndex:indexPath.row] isEqualToString:@""]) {
        // check to see if Header data is also in history
        if([favoriteHEADER objectAtIndex:indexPath.row] && ![[favoriteHEADER objectAtIndex:indexPath.row] isEqualToString:@""]) {
            cell.detailTextLabel.numberOfLines = 3;
            //cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
            NSString *str = [favoriteHEADER objectAtIndex:indexPath.row];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"↵"];
            str = [str stringByTruncatingString:str toWidth:trimWidth withFont:cell.detailTextLabel.font];
            NSString *str2 = [favoritePOST objectAtIndex:indexPath.row];
            str2 = [str2 stringByReplacingOccurrencesOfString:@"\n" withString:@"↵"];
            str2 = [str2 stringByTruncatingString:str2 toWidth:trimWidth withFont:cell.detailTextLabel.font];
            cell.detailTextLabel.text = [NSString stringWithFormat:@" ⓟ %@\n ⓗ %@",str2,str];
        }
        else {
            NSString *str = [favoritePOST objectAtIndex:indexPath.row];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"↵"];
            str = [str stringByTruncatingString:str toWidth:trimWidth withFont:cell.detailTextLabel.font];
            cell.detailTextLabel.text = [NSString stringWithFormat:@" ⓟ %@",str];
        }
    }
    else if([favoriteHEADER objectAtIndex:indexPath.row] && ![[favoriteHEADER objectAtIndex:indexPath.row] isEqualToString:@""]) {
            NSString *str = [favoriteHEADER objectAtIndex:indexPath.row];
            str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"↵"];
            str = [str stringByTruncatingString:str toWidth:trimWidth withFont:cell.detailTextLabel.font];
            cell.detailTextLabel.text = [NSString stringWithFormat:@" ⓗ %@",str];
    }
    return cell;
}

//  Answer TableView action - Row selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL needSave = NO;
    //NSLog([NSString stringWithFormat:@"didSelectRowAtIndexPath: %d:%@", indexPath.row, [favoriteURLs objectAtIndex:indexPath.row]]);
    _urlText.text = [favoriteURLs objectAtIndex:indexPath.row]; // load URL into UI field
    // find out if this was a POST history
    
    if([favoritePOST objectAtIndex:indexPath.row] && ![[favoritePOST objectAtIndex:indexPath.row] isEqualToString:@""]) {
        // switch selector to POST
        _httpReq.selectedSegmentIndex = 2L;
        userPost = [favoritePOST objectAtIndex:indexPath.row]; // load POST data
        needSave = YES;
    }
    else {
        //userPost = @"";
        if(_httpReq.selectedSegmentIndex == 2L) _httpReq.selectedSegmentIndex = 0L; // unselect POST
    }
    if([favoriteHEADER objectAtIndex:indexPath.row] && ![[favoriteHEADER objectAtIndex:indexPath.row] isEqualToString:@""]) {
        // add header data
        userHeaders = [favoriteHEADER objectAtIndex:indexPath.row]; // load HEADER data
        needSave = YES;
    }
    else if(![userHeaders isEqualToString:@""]) {
        userHeaders = @"";
        needSave = YES;
    };
    
    if(needSave)  [self saveSettings]; // update POST and HEADER data in settings
    
    _urlDropdown.hidden=YES;  // hide the dropdown
    
    // inform user to press go - allowing them to made other changes
    _resultText.text = @"\n\n\n⊣ Select options or tap Go to Continue ⊢";
    _resultText.textAlignment = NSTextAlignmentCenter;
    [_resultText setTextColor:[UIColor blackColor]];
    
    [_urlText resignFirstResponder]; // remove keyboard

    
    //[self Go:(self)]; // force Go action method to load URL
}


//
// SETTINGS - User Controlled Settings
//

// Load Settings from Settings.plist

- (IBAction)loadSettings
{
    NSError *error;
    BOOL success;
    
    // Do any additional setup after loading the view from its nib.
    
    // Load settings from plist
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"Settings.plist"];
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:destPath]) {
        //NSLog(@"Creating Settings Plist in Document Store");
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        success = [fileManager copyItemAtPath:sourcePath toPath:destPath error:&error];
        if(!success)
            NSLog(@"Failed to create plist [from %@ to %@] (%@)",sourcePath, destPath, error);
    }
    // Load the Property List.
    settingsdata = [[NSMutableDictionary alloc] initWithContentsOfFile:destPath];
    //NSLog(@"Loading from %@ - settings.plist: %@",destPath, settingsdata);
    // populate data fields with settingsdata
    userAgent = settingsdata[@"userAgent"];
    userName = settingsdata[@"userName"];
    userPass = settingsdata[@"userPass"];
    userAuthBasic = [settingsdata[@"userAuthBasic"] boolValue];
    userAuthDigest = [settingsdata[@"userAuthDigest"] boolValue];
    userAuthNTLM = [settingsdata[@"userAuthNTLM"] boolValue];
    userAuthNegotiate = [settingsdata[@"userAuthNegotiate"] boolValue];
    userHeaders = settingsdata[@"userHeaders"];
    userPost = settingsdata[@"userPost"];
    userInsecure = [settingsdata[@"userInsecure"] boolValue];
    if(settingsdata[@"userTimeout"] && settingsdata[@"userSSLv3"])  {
        userTimeout = settingsdata[@"userTimeout"];
        userSSLv3 = [settingsdata[@"userSSLv3"] boolValue];
    }
    else {
        // upgrade plist
        userTimeout = [NSNumber numberWithInt:30]; // default to 30s
        userSSLv3 = NO;
        [self saveSettings];
        NSLog(@"Upgraded Settings.plist for v1.4");
    }
    if(settingsdata[@"userHTTP2"] && settingsdata[@"userCertDetail"] && settingsdata[@"userIPv4"] && settingsdata[@"userIPv6"]) {
        userHTTP2 = [settingsdata[@"userHTTP2"] boolValue];
        userCertDetail = [settingsdata[@"userCertDetail"] boolValue];
        userIPv4 = [settingsdata[@"userIPv4"] boolValue];
        userIPv6 = [settingsdata[@"userIPv6"] boolValue];
    }
    else {
        // upgrade plist
        userHTTP2 = YES;
        userCertDetail = NO;
        userIPv4 = YES;
        userIPv6 = YES;
        [self saveSettings];
        NSLog(@"Upgraded Settings.plist for v1.6");
    }
    if(settingsdata[@"userResolve"]) {
        userResolve = settingsdata[@"userResolve"];
    }
    else {
        userResolve = @"";
        [self saveSettings];
        NSLog(@"Upgraded Settings.plist for 1.7");
    }
    if(settingsdata[@"userConnectTimeout"])  {
        userConnectTimeout = settingsdata[@"userConnectTimeout"];
    }
    else {
        // upgrade plist
        userConnectTimeout = [NSNumber numberWithInt:5]; // default to 5s
        [self saveSettings];
        NSLog(@"Upgraded Settings.plist for v1.9");
    }

}

- (IBAction)saveSettings
{
    // save settings to plist
    BOOL success;

    settingsdata[@"userAgent"] = userAgent;
    settingsdata[@"userName"] = userName;
    settingsdata[@"userPass"] = userPass;
    settingsdata[@"userAuthBasic"] = [NSNumber numberWithBool:userAuthBasic];
    settingsdata[@"userAuthDigest"] = [NSNumber numberWithBool:userAuthDigest];
    settingsdata[@"userAuthNTLM"] = [NSNumber numberWithBool:userAuthNTLM];
    settingsdata[@"userAuthNegotiate"] = [NSNumber numberWithBool:userAuthNegotiate];
    settingsdata[@"userAuthAny"] = [NSNumber numberWithBool:userAuthAny];
    settingsdata[@"userHeaders"] = userHeaders;
    settingsdata[@"userPost"] = userPost;
    settingsdata[@"userInsecure"] = [NSNumber numberWithBool:userInsecure];
    settingsdata[@"userTimeout"] = userTimeout;
    settingsdata[@"userConnectTimeout"] = userConnectTimeout;
    settingsdata[@"userSSLv3"] = [NSNumber numberWithBool:userSSLv3];
    settingsdata[@"userHTTP2"] = [NSNumber numberWithBool:userHTTP2];
    settingsdata[@"userCertDetail"] = [NSNumber numberWithBool:userCertDetail];
    settingsdata[@"userIPv4"] = [NSNumber numberWithBool:userIPv4];
    settingsdata[@"userIPv6"] = [NSNumber numberWithBool:userIPv6];
    settingsdata[@"userResolve"] = userResolve;
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"Settings.plist"];
    success  = [settingsdata writeToFile:destPath atomically:YES];
    if (!success)
        NSLog(@"Failed to write to url.plist: %@",destPath);

}

- (IBAction)favoritesReset
{
    // reset URL, Post and Header Data History
    BOOL success;
    
    // delete all history
    if ([favoriteURLs count] > 0) {
        [favoriteURLs removeAllObjects];
    }
    if ([favoritePOST count] > 0) {
        [favoritePOST removeAllObjects];
    }
    if ([favoriteHEADER count] > 0) {
        [favoriteHEADER removeAllObjects];
    }

    // Add placeholder URL to favorites
    NSString *urlToAdd = @"http://www.apple.com";
    NSString *postToAdd = @"";
    NSString *headerToAdd = @"";
    [favoriteURLs insertObject:(urlToAdd) atIndex:(0) ];
    [favoritePOST insertObject:(postToAdd) atIndex:(0) ];
    [favoriteHEADER insertObject:(headerToAdd) atIndex:(0)];
    
    // Save favorites to urls.plist
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"urls.plist"];
    success  = [favoriteURLs writeToFile:destPath atomically:YES];
    if (!success) {
        NSLog(@"Failed to write to url.plist: %@",destPath);
    }
    // Saving POST data to urlspost.plist
    NSString *destPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath2 = [destPath2 stringByAppendingPathComponent:@"urlspost.plist"];
    success  = [favoritePOST writeToFile:destPath2 atomically:YES];
    if (!success) {
        NSLog(@"Failed to write to urlpost.plist: %@",destPath2);
    }
    // Saving HEADER data to urlsheader.plist
    NSString *destPath3 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath3 = [destPath3 stringByAppendingPathComponent:@"urlsheader.plist"];
    success  = [favoriteHEADER writeToFile:destPath3 atomically:YES];
    if (!success) {
        NSLog(@"Failed to write to urlheader.plist: %@",destPath3);
    }
    
    // reset main view
    [_urlDropdown reloadData]; // reload tableview data
    _urlText.text = @""; // clear URL field
    _progress.hidden = NO;
    _resultText.text = @""; // clear viewer
    _timings.text = @"NS: ----   TCP: ----    SSL: ----    FB: ----    Total: ----"; // clear timings
    _timings.hidden=NO; // unhide timing data
    _progress.progress = 0.0; // start progress bar at zero

}

@end

//
// Private methods
//

@implementation iCHViewController (Private)


- (size_t)copyUpToThisManyBytes:(size_t)bytes intoThisPointer:(void *)pointer
{
	size_t bytesToGo = _dataToSend.length-_dataToSendBookmark;
	size_t bytesToGet = MIN(bytes, bytesToGo);
	
	if (bytesToGo)
	{
		[_dataToSend getBytes:pointer range:NSMakeRange(_dataToSendBookmark, bytesToGet)];
		_dataToSendBookmark += bytesToGet;
		return bytesToGet;
	}
	return 0U;
}

- (void)insertText:(NSString *)text
{
    //if(waitForUser) NSLog(@"insertText: **Wait for User**");
    // check to see if we have prompted user with an alert box
    if(waitForUser) {
        // pause processing
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }

    _resultText.text = [_resultText.text stringByAppendingString:text];
    
    downloadedSize = _resultText.text.length;
    if(downloadedSize > fileSize) fileSize = fileSize*2;
    float perProgress;
    
    perProgress = (float)downloadedSize/fileSize;
    if(perProgress>0.95) perProgress = 0.95; // force 5% buffer until closed by  main thread
    _progress.progress = perProgress;
    
    //NSLog(@"insertText : %ld/%ld = %1.2f", downloadedSize, fileSize, perProgress);
    
    // check for large file - present option to cancel
    if((downloadedSize > 200000 || (fileSize > 200000 && downloadedSize > 10000)) && !largefileAlert) {
        largefileAlert = TRUE;
        waitForUser = TRUE;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        
        UIAlertController *myAlertControllerd = [UIAlertController
                                                 alertControllerWithTitle:@"Large File Warning"
                                                 message:@"HTML download exceeds 200k"
                                                 preferredStyle:UIAlertControllerStyleAlert                   ];
        
        // Create a UIAlertAction that can be added to the alert
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     // flag for download cancelation
                                     self->globalReset = 2;
                                     [myAlertControllerd dismissViewControllerAnimated:YES completion:nil];
                                     waitForUser = FALSE; // unblock thread
                                 }];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 // dismiss the alertwindow
                                 [myAlertControllerd dismissViewControllerAnimated:YES completion:nil];
                                 waitForUser = FALSE; // unblock thread
                             }];
        
        // Add the UIAlertAction ok that we just created to our AlertController
        [myAlertControllerd addAction: cancel];
        [myAlertControllerd addAction: ok];
        
        // Present the alert to the user
        [self presentViewController:myAlertControllerd animated:YES completion:nil];
        /*
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Large File Warning"
                                                        message:@"HTML download exceeds 200k"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles: nil];

        [alert setTag:12];
        [alert addButtonWithTitle:@"Continue"];
        [alert show];
        */
    }
    
    // force the run loop to run and do rendering while curl_easy_perform() hasn't returned yet
    // rendering slows down drastically with large html files - increase runloop time for larger files
    if(largefileAlert)
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]]; // up render time
    else
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    ;

}

- (void)insertTextv:(NSString *)text
{
    //if(waitForUser) NSLog(@"insertTextv: **Wait for User**");
    // check to see if we have prompted user with an alert box
    if(waitForUser) {
        // pause processing
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
	@autoreleasepool {
         if(_verbose.selectedSegmentIndex == 1L) {
             _resultText.text = [_resultText.text stringByAppendingString:text];
             
             downloadedSize = _resultText.text.length;
             if(downloadedSize > fileSize) fileSize = fileSize*1.5;
             float perProgress;
             
             perProgress = (float)downloadedSize/fileSize;
             if(perProgress>0.95) perProgress = 0.95; // force 5% buffer until closed by  main thread
             _progress.progress = perProgress;
             
             //NSLog(@"insertTextv : %ld/%ld = %1.2f", downloadedSize, fileSize, perProgress);
             
             [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
             // force the run loop to run and do drawing while curl_easy_perform() hasn't returned yet
         }
	}
}

- (void)updateProgress:(double *)per
{
    //NSLog(@"updateProgress: %f", *(per));
    _progress.progress = *(per);
}

- (void)receivedData:(NSData *)data
{
    //if(waitForUser) NSLog(@"receivedData: **Wait for User**");
    // check to see if we have prompted user with an alert box
    while(waitForUser) {
        // pause processing
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
	//[_dataReceived appendData:data];
}

- (void)rewind
{
	_dataToSendBookmark = 0U;
}

- (int)DOglobalReset
{
    if(globalReset>1) {
        globalReset = 1;
        return 2;
    }
    return globalReset;
}


@end
