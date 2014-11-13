//
//  FRViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/10/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "FRViewController.h"
#import "AddDetailsViewController.h"
#import "RequestDetailsViewController.h"

@interface FRViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation FRViewController
@synthesize searchedUser;
@synthesize currentUser;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.requests = [[NSMutableArray alloc] init];
    self.requestsUsernames = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    currentUser = [[QBChat instance] currentUser];
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"user_id"];
    
    //make request
    [QBRequest objectsWithClassName:@"FriendRequests" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        // response processing;
        QBCOCustomObject *list = [objects objectAtIndex:0];
        [QBRequest updateObject:list successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            _requests = [[list.fields objectForKey:@"friendRequests"]mutableCopy];
            _requestsUsernames = [[list.fields objectForKey:@"usernames"] mutableCopy];
            NSLog(@"list arrays updated with %lu objects", (unsigned long)_requests.count);
            [self.tableView reloadData];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Could not access custom object. Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"No object found when searching for custom object. Response error: %@", [response.error description]);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"requests number of rows: %lu", (unsigned long)_requests.count);
    return [self.requestsUsernames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.requestsUsernames[indexPath.row]];
    return cell;
}

- (IBAction)searchPressed:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Search for User" message:@"Please enter the username of the user you wish to add." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        NSString *text = [[alertView textFieldAtIndex:0] text];
        if( ([currentUser.login caseInsensitiveCompare:text] == NSOrderedSame) && text!=nil) {
            UIAlertView *SearchFailed = [[UIAlertView alloc]initWithTitle:@"Search Failed" message:@"Cannot add yourself." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [SearchFailed show];
            // strings are equal except for possibly case
        }
        else if(text!=nil){
            NSLog(@"Entered: %@",text);
            [QBRequest userWithLogin:text
                        successBlock:^(QBResponse *response, QBUUser *user){
                            NSLog(@"QBUUser login: %@",user.login );
                            searchedUser = user;
                            [self performSegueWithIdentifier:@"toAddDetails" sender:self];
                            
                        }errorBlock:^(QBResponse *response){
                            NSString * error = [response.error description];
                            NSLog(@"error is this: %@",error);
                            UIAlertView *SearchFailed = [[UIAlertView alloc]initWithTitle:@"Search Failed" message:@"Could not find user." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                            [SearchFailed show];
                        }];
            
        }
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"toAddDetails"]){
        NSLog(@"QBChat add called");
        AddDetailsViewController *vc = [segue destinationViewController];
        vc.user = searchedUser;
    }
    
    else if ([segue.identifier isEqualToString:@"RequestDetails"]){
        int target = [[self.requests objectAtIndex:[[self.tableView indexPathForSelectedRow] row]] integerValue];
        RequestDetailsViewController *vc = segue.destinationViewController;
        vc.userID = target;
        NSInteger index = [[self.tableView indexPathForSelectedRow] row];
        vc.index = index;
        
        vc.otherUsername = [self.requestsUsernames objectAtIndex:index];
        vc.otherID = [self.requests objectAtIndex:index];
        vc.requests = self.requests;
        vc.requestsUsernames = self.requestsUsernames;
    }
    
}

- (IBAction)cancelPressed:(id)sender {
    [self performSegueWithIdentifier:@"toFriendsList" sender:self];
}
@end
