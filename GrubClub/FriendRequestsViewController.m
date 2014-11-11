//
//  FriendRequestsViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/9/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "FriendRequestsViewController.h"
#import "AddDetailsViewController.h"

@interface FriendRequestsViewController ()
- (IBAction)searchPressed:(id)sender;
@property NSMutableArray *requests;
@end

@implementation FriendRequestsViewController
@synthesize searchedUser;
@synthesize currentUser;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.requests = [[NSMutableArray alloc] init];
    currentUser = [[QBChat instance] currentUser];
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"_user_id"];
    
    
    //make request
    [QBRequest objectsWithClassName:@"FriendRequests" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        // response processing
        NSLog(@"Friend request list obtained. objects in objects array: %lu", (unsigned long)objects.count);
        QBCOCustomObject *test2 = [objects objectAtIndex:0];
        [QBRequest updateObject:test2 successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            NSLog(@"SUCESS WUUUUUT");
            _requests = [[test2.fields objectForKey:@"friendRequests"]mutableCopy];
            NSLog(@"request array has count of: %lu", (unsigned long)_requests.count);
            
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"FAILED WUUUUUT");
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"finding current user friendrequests failed");
        NSLog(@"Response error: %@", [response.error description]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"pending count: %lu",self.requests.count);
//    return self.pending.count;
    return 0;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toAddDetails"]){
        NSLog(@"search pressed");
//        [[QBChat instance] addUserToContactListRequest:1892667];
        NSLog(@"QBChat add called");
        AddDetailsViewController *vc = [segue destinationViewController];
        vc.user = searchedUser;
        
    }
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.requests objectAtIndex:indexPath.row] login];
    //    cell.detailTextLabel.text = [[self.contacts objectAtIndex:indexPath.row] phone];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)searchPressed:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter the username of the user you wish to add." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        NSString *text = [[alertView textFieldAtIndex:0] text];
        NSLog(@"Entered: %@",text);
        [QBRequest userWithLogin:text
                    successBlock:^(QBResponse *response, QBUUser *user){
                        NSLog(@"found him!!!");
                        NSLog(@"QBUUser login: %@",user.login );
                        searchedUser = user;
                        [self performSegueWithIdentifier:@"toAddDetails" sender:self];
                        
                    }errorBlock:^(QBResponse *response){
                        NSLog(@"Search failed");
                        NSString * error = [response.error description];
                        NSLog(@"error is this: %@",error);
                        UIAlertView *SearchFailed = [[UIAlertView alloc]initWithTitle:@"Search Failed" message:@"Could not find user." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                        [SearchFailed show];
                    }];
    }
    
}

@end
