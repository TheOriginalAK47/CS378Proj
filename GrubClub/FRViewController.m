//
//  FRViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/10/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "FRViewController.h"
#import "AddDetailsViewController.h"

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
            NSLog(@"object at index 0: %@" , [_requests objectAtIndex:0]);
            [self.tableView reloadData];
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

- (void) convertToStrings {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"requests number of rows: %lu", (unsigned long)_requests.count);
    return [self.requests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    cell.textLabel.text = self.requests[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.requests[indexPath.row]];
    return cell;
}

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
