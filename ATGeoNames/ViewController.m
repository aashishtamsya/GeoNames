//
//  ViewController.m
//  ATGeoNames
//
//  Created by Felix ITs 01 on 27/07/16.
//  Copyright © 2016 Aashish Tamsya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *allCountryNames;

@property (nonatomic, strong) NSArray *allCountryCodes;

@property (nonatomic, strong) NSString *countryCode;

@property (nonatomic, strong) NSDictionary *countryDetailsDictionary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Make self the delegate of the textfield.
    self.textFieldCountrySearch.delegate = self;
    
    // Make self the delegate and datasource of the table view.
    self.tableViewDetails.delegate = self;
    self.tableViewDetails.dataSource = self;
    
    // Initially hide the table view.
    self.tableViewDetails.hidden = YES;
    
    
    // Load the contents of the two .txt files to the arrays.
    NSString *pathOfCountriesFile = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"txt"];
    NSString *pathOfCountryCodesFile = [[NSBundle mainBundle] pathForResource:@"countries_short" ofType:@"txt"];
    
    NSString *countries = [NSString stringWithContentsOfFile:pathOfCountriesFile encoding:NSUTF8StringEncoding error:nil];
    self.allCountryNames = [[NSArray alloc] initWithArray:[countries componentsSeparatedByString:@"\n"]];
    
    NSString *countryCodes = [NSString stringWithContentsOfFile:pathOfCountryCodesFile encoding:NSUTF8StringEncoding error:nil];
    self.allCountryCodes = [[NSArray alloc] initWithArray:[countryCodes componentsSeparatedByString:@"\n"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCountryInfo {
    
    NSString *URLString = [NSString stringWithFormat:@"http://api.geonames.org/countryInfoJSON?username=%@&country=%@", kUsername, self.countryCode];
    NSURL *url = [NSURL URLWithString:URLString];
    
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        // Check if any data returned.
        if (data != nil) {
            // Convert the returned data into a dictionary.
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else{
                self.countryDetailsDictionary = [[returnedDict objectForKey:@"geonames"] objectAtIndex:0];
                NSLog(@"%@", self.countryDetailsDictionary);
                
                 self.labelCountryName.text = [NSString stringWithFormat:@"%@ (%@)", [self.countryDetailsDictionary objectForKey:@"countryName"], [self.countryDetailsDictionary objectForKey:@"countryCode"]];
                
                [self.tableViewDetails reloadData];
                
                // Show the table view.
                self.tableViewDetails.hidden = NO;
            }
        }
    }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

#pragma mark UITableView Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = @"Capital";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"capital"];
            break;
        case 1:
            cell.detailTextLabel.text = @"Continent";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"continentName"];
            break;
        case 2:
            cell.detailTextLabel.text = @"Population";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"population"];
            break;
        case 3:
            cell.detailTextLabel.text = @"Area in Square Km";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"areaInSqKm"];
            break;
        case 4:
            cell.detailTextLabel.text = @"Currency";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"currencyCode"];
            break;
        case 5:
            cell.detailTextLabel.text = @"Languages";
            cell.textLabel.text = [self.countryDetailsDictionary objectForKey:@"languages"];
            break;
        case 6:
            cell.textLabel.text = @"Neighbour Countries";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
            
        default:
            break;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {

        NeighboursViewController *neighboursViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NeighboursViewController"];
        
        neighboursViewController.geonameID = [self.countryDetailsDictionary objectForKey:@"geonameId"];
        
        [self.navigationController pushViewController:neighboursViewController animated:YES];
        
        //        [self performSegueWithIdentifier:@"idSegueNeighbours" sender:self];
    }
}


#pragma mark UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // Find the index of the typed country in the arrCountries array.
    NSInteger index = -1;
    for (NSUInteger i=0; i<self.allCountryNames.count; i++) {
        NSString *currentCountry = [self.allCountryNames objectAtIndex:i];
        if ([currentCountry rangeOfString:self.textFieldCountrySearch.text.uppercaseString].location != NSNotFound) {
            index = i;
            break;
        }
    }
    
    // Check if the given country was found.
    if (index != -1) {
        // Get the two-letter country code from the arrCountryCodes array.
        self.countryCode = [self.allCountryCodes objectAtIndex:index];
        [self getCountryInfo];
    }
    else{
        // If the country was not found then show an alert view displaying a relevant message.
        [[[UIAlertView alloc] initWithTitle:@"Country Not Found" message:@"The country you typed in was not found." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
    }
    
    
    // Hide the keyboard.
    [self.textFieldCountrySearch resignFirstResponder];
    
    return YES;
}


- (IBAction)composeBarButtonTapped:(id)sender {
    
    // Create a dictionary containing only the values we care about.
    NSDictionary *dictionary = @{@"countryName": [self.countryDetailsDictionary objectForKey:@"countryName"],
                                 @"countryCode": [self.countryDetailsDictionary objectForKey:@"countryCode"],
                                 @"capital": [self.countryDetailsDictionary objectForKey:@"capital"],
                                 @"continent": [self.countryDetailsDictionary objectForKey:@"continentName"],
                                 @"population": [self.countryDetailsDictionary objectForKey:@"population"],
                                 @"areaInSqKm": [self.countryDetailsDictionary objectForKey:@"areaInSqKm"],
                                 @"currency": [self.countryDetailsDictionary objectForKey:@"currencyCode"],
                                 @"languages": [self.countryDetailsDictionary objectForKey:@"languages"]
                                 };
    
    // Convert the dictionary into a JSON data object.
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
 
    // Convert the JSON data into a string.
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
 
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        
        [mailViewController setSubject:@"Country JSON"];
        
        [mailViewController setMessageBody:JSONString isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
