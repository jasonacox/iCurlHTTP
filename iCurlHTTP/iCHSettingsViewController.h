//
//  iCHSettingsViewController.h
//  iCurlHTTP
//
//  Created by Jason Cox on 6/1/14.
//  Copyright (c) 2014 Jason Cox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "iCHSettingsForm.h"

@interface iCHSettingsViewController : UIViewController <FXFormControllerDelegate>
{
    // global data
    NSMutableDictionary *settingsdata;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FXFormController *formController;

- (IBAction)dismissModalView:(id)sender;
- (IBAction)cancelSettings:(id)sender;
- (IBAction)clearHistory:(id)sender;
// - (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
