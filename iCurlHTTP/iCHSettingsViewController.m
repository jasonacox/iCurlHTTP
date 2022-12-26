//
//  iCHSettingsViewController.m
//  iCurlHTTP
//
//  Created by Jason Cox on 6/1/14.
//  Copyright (c) 2014 Jason Cox. All rights reserved.
//

#import "iCHSettingsViewController.h"
#import "iCHSettingsForm.h"
#import "FXForms.h"
#import "iCHViewController.h"
#import "iCHColors.h"

@interface iCHSettingsViewController ()

@end

@implementation iCHSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set up form and form controller
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[iCHSettingsForm alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // load plist data for form
    iCHSettingsForm *formdata = self.formController.form;
    
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
    formdata.userAgent = settingsdata[@"userAgent"];
    formdata.userName = settingsdata[@"userName"];
    formdata.userPass = settingsdata[@"userPass"];
    formdata.userAuthBasic = [settingsdata[@"userAuthBasic"] boolValue];
    formdata.userAuthDigest = [settingsdata[@"userAuthDigest"] boolValue];
    formdata.userAuthNTLM = [settingsdata[@"userAuthNTLM"] boolValue];
    formdata.userAuthNegotiate = [settingsdata[@"userAuthNegotiate"] boolValue];
    formdata.userAuthAny = [settingsdata[@"userAuthAny"] boolValue];
    formdata.userHeaders = settingsdata[@"userHeaders"];
    formdata.userPost = settingsdata[@"userPost"];
    formdata.userInsecure = [settingsdata[@"userInsecure"] boolValue];
    if(settingsdata[@"userTimeout"] && settingsdata[@"userSSLv3"])  {
        formdata.userTimeout = settingsdata[@"userTimeout"];
        formdata.userSSLv3 = [settingsdata[@"userSSLv3"] boolValue];
    }
    else {
        // upgrade plist
        formdata.userTimeout = [NSNumber numberWithInt:30]; // default to 30s
        formdata.userSSLv3 = NO;

        NSLog(@"Settings.plist -- Missing userTimeout and userSSLv3");
    }
    if(settingsdata[@"userHTTP2"])    formdata.userHTTP2 = [settingsdata[@"userHTTP2"] boolValue];
    else {
        // upgrade plist
        formdata.userHTTP2 = YES;
        NSLog((@"Settings.plist -- Missing userHTTP2"));
    }
    if(settingsdata[@"userCertDetail"] && settingsdata[@"userIPv4"] && settingsdata[@"userIPv6"])    {
        formdata.userCertDetail = [settingsdata[@"userCertDetail"] boolValue];
        formdata.userIPv4 = [settingsdata[@"userIPv4"] boolValue];
        formdata.userIPv6 = [settingsdata[@"userIPv6"] boolValue];
    }
    else {
        // upgrade plist
        formdata.userCertDetail = NO;
        formdata.userIPv4 = YES;
        formdata.userIPv6 = YES;
        NSLog((@"Settings.plist -- Missing userCertDetail, userIPv4, and userIPv6"));
    }
    if(settingsdata[@"userResolve"]) {
        formdata.userResolve = settingsdata[@"userResolve"];
    }
    else {
        formdata.userResolve = @"";
        NSLog(@"Settings.plist -- Missing userResolve");
    }
    if(settingsdata[@"userConnectTimeout"]) formdata.userConnectTimeout = settingsdata[@"userConnectTimeout"];
    else {
        // upgrade plist
        formdata.userConnectTimeout = [NSNumber numberWithInt:5]; // default to 5s
        
        NSLog(@"Settings.plist -- Missing userConnectTimeout");
    }
    //reload the table
    [self.tableView reloadData];
    
}

- (IBAction)dismissModalView:(id)sender{
    
    BOOL success;
    [self.tableView endEditing:YES]; // save edits

    // save settings to plist
    iCHSettingsForm *formdata = self.formController.form;
    settingsdata[@"userAgent"] = formdata.userAgent;
    settingsdata[@"userName"] = formdata.userName;
    settingsdata[@"userPass"] = formdata.userPass;
    settingsdata[@"userAuthBasic"] = [NSNumber numberWithBool:formdata.userAuthBasic];
    settingsdata[@"userAuthDigest"] = [NSNumber numberWithBool:formdata.userAuthDigest];
    settingsdata[@"userAuthNTLM"] = [NSNumber numberWithBool:formdata.userAuthNTLM];
    settingsdata[@"userAuthNegotiate"] = [NSNumber numberWithBool:formdata.userAuthNegotiate];
    settingsdata[@"userAuthAny"] = [NSNumber numberWithBool:formdata.userAuthAny];
    settingsdata[@"userHeaders"] = formdata.userHeaders;
    settingsdata[@"userPost"] = formdata.userPost;
    settingsdata[@"userInsecure"] = [NSNumber numberWithBool:formdata.userInsecure];
    settingsdata[@"userTimeout"] = formdata.userTimeout;
    settingsdata[@"userConnectTimeout"] = formdata.userConnectTimeout;
    settingsdata[@"userSSLv3"] = [NSNumber numberWithBool:formdata.userSSLv3];
    settingsdata[@"userHTTP2"] = [NSNumber numberWithBool:formdata.userHTTP2];
    settingsdata[@"userCertDetail"] = [NSNumber numberWithBool:formdata.userCertDetail];
    settingsdata[@"userIPv4"] = [NSNumber numberWithBool:formdata.userIPv4];
    settingsdata[@"userIPv6"] = [NSNumber numberWithBool:formdata.userIPv6];
    settingsdata[@"userResolve"] = formdata.userResolve;
    //NSLog(@"trying to save: %@",settingsdata);
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    destPath = [destPath stringByAppendingPathComponent:@"Settings.plist"];
    success  = [settingsdata writeToFile:destPath atomically:YES];
    if (!success)
        NSLog(@"Failed to write to url.plist: %@",destPath);
    
    // need to notify parent to reload this data
    //NSLog(@"presentingViewController: %@",self.presentingViewController);
    if([self.presentingViewController isKindOfClass:[iCHViewController class]]) {
        iCHViewController* viewController = (iCHViewController*)self.presentingViewController;
        //NSLog(@"::trying to notify parent::");
        [viewController loadSettings];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //NSLog(@"Updating Color Mode ** ");
    // Support for iOS 13 and Dark Mode
    if (@available(iOS 13.0, *)) {
        // Dark Mode On
           if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
               // iOS 13 in DARK mode
               [self.view setBackgroundColor:[UIColor UIDARKBACKGROUND2]];
           }
           else {
               // iOS 13  in LIGHT mode
               [self.view setBackgroundColor:[UIColor UILIGHTBACKGROUND]];
           }
       } else {
           // Not iOS 13 - no updates
    }
}

- (IBAction)cancelSettings:(id)sender{
        [self dismissViewControllerAnimated:YES completion:nil];
}
//
// User options - Custom Headers
//
-(IBAction)Reset:(id)sender {
    iCHSettingsForm *formdata = self.formController.form;
    formdata.userAgent = [@"" stringByAppendingFormat:@"iCurlHTTP/%@ %s", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], curl_version()];
    formdata.userName = @"";
    formdata.userPass = @"";
    formdata.userAuthBasic = YES;
    formdata.userAuthDigest = NO;
    formdata.userAuthNTLM = NO;
    formdata.userAuthNegotiate = NO;
    formdata.userAuthAny = NO;
    formdata.userHeaders = @"";
    formdata.userPost = @"firstname=Post&lastname=Robot";
    formdata.userInsecure = YES;
    formdata.userTimeout = [NSNumber numberWithInteger:30];
    formdata.userConnectTimeout = [NSNumber numberWithInteger:5];
    formdata.userSSLv3 = NO;
    formdata.userHTTP2 = YES;
    formdata.userCertDetail = NO;
    formdata.userIPv4 = YES;
    formdata.userIPv6 = YES;
    formdata.userResolve = @"";
    //reload the table
    [self.tableView reloadData];
}

-(IBAction)clearHistory:(id)sender {
    // reset URL history
    // prompt for confirmation
    UIAlertController *myAlertController = [UIAlertController
                                            alertControllerWithTitle:@"Clear History"
                                            message: @"Reset URL and POST data history?"
                                            preferredStyle:UIAlertControllerStyleAlert                   ];

    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"Yes"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              // tell parent to reset history - URL and POST favorites
                              if([self.presentingViewController isKindOfClass:[iCHViewController class]]) {
                                  iCHViewController* viewController = (iCHViewController*)self.presentingViewController;
                                  //NSLog(@"::trying to notify parent to reset history::");
                                  [viewController favoritesReset];
                              }
                          }];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             // dismiss the alertwindow
                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [myAlertController addAction: no];
    [myAlertController addAction: yes];
    [self presentViewController:myAlertController animated:YES completion:nil];
    
    /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Clear History"
                                                            message:@"Reset URL and POST data history?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
    
*/
    
}

/* REMOVE
// reset history verify
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Answered NO to clear history
        //NSLog(@"No");
    }
    else {
        // Answered YES to clear history
        // reset URL and Post data history
        //NSLog(@"Yes");
        // tell parent to reset history - URL and POST favorites
        if([self.presentingViewController isKindOfClass:[iCHViewController class]]) {
            iCHViewController* viewController = (iCHViewController*)self.presentingViewController;
            //NSLog(@"::trying to notify parent to reset history::");
            [viewController favoritesReset];
        }
    }
}
*/

@end
