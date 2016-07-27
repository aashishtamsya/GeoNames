//
//  ViewController.h
//  ATGeoNames
//
//  Created by Felix ITs 01 on 27/07/16.
//  Copyright © 2016 Aashish Tamsya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *textFieldCountrySearch;

@property (weak, nonatomic) IBOutlet UITableView *tableViewDetails;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonCompose;

- (IBAction)composeBarButtonTapped:(id)sender;

-(void)getCountryInfo;

@end

