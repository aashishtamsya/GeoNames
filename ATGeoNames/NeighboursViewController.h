//
//  NeighboursViewController.h
//  JSONAndXMLDemo
//
//  Created by Gabriel Theodoropoulos on 24/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NeighboursViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate>


@property (nonatomic, strong) NSString *geonameID;

@property (weak, nonatomic) IBOutlet UITableView *tableViewNeighbouringCountries;

-(void)downloadNeighbourCountries;



@property (nonatomic, strong) NSXMLParser *xmlParser;

@property (nonatomic, strong) NSMutableArray *allNeightbouringCountries;

@property (nonatomic, strong) NSMutableDictionary *dictTempDataStorage;

@property (nonatomic, strong) NSMutableString *foundValue;

@property (nonatomic, strong) NSString *currentElement;


@end
