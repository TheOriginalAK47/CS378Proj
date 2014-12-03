//
//  FLViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/12/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "FLViewController.h"
#import "ChatService.h"
@interface FLViewController ()
- (IBAction)signoutPressed:(id)sender;
- (IBAction)addPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FLViewController
@synthesize currentUser;

- (void)viewDidLoad {
    [super viewDidLoad];
//    [NSTimer scheduledTimerWithTimeInterval:30 target:[QBChat instance] selector:@selector(sendPresence) userInfo:nil repeats:YES];
    NSLog(@"friendslist viewcontroller called");
    // Do any additional setup after loading the view.
    [[ChatService instance] setViewController:self];
    self.friendsList = [[NSMutableArray alloc] init];
    self.usernames = [[NSMutableArray alloc] init];
    currentUser = [[QBChat instance] currentUser];
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    NSMutableDictionary *getSeshRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"user_id"];
    [getSeshRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"user_id"];
    
    [QBRequest objectsWithClassName:@"activeSession" extendedRequest:getSeshRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        // response processing;
        QBCOCustomObject *session = [objects objectAtIndex:0];
        [session.fields setObject:@"True" forKey:@"online"];
        [QBRequest updateObject:session successBlock:^(QBResponse *response, QBCOCustomObject *session) {
            // object updated
            //NSLog(@"Type of session object: %@", NSStringFromClass([session class]));
            NSLog(@"Seemed to have updated the sesh sucessfully!");
            //NSLog(@"%lu", (unsigned long)session.userID);
            
            [self.tableView reloadData];
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Could not update custom object. Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"No object found when searching for custom object. Response error: %@", [response.error description]);
    }];
    
    //make request
    [QBRequest objectsWithClassName:@"FriendsList" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        // response processing;
        QBCOCustomObject *list = [objects objectAtIndex:0];
        [QBRequest updateObject:list successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            _friendsList = [[list.fields objectForKey:@"friendsList"]mutableCopy];
            _usernames = [[list.fields objectForKey:@"usernames"] mutableCopy];
            NSLog(@"list arrays updated with %lu objects", (unsigned long)_usernames.count);
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"videoSegue"]) {
        MainViewController *vc = [segue destinationViewController];
        int tableIndex = [[self.tableView indexPathForSelectedRow] row];
        vc.opponentID = [self.friendsList objectAtIndex:tableIndex];
        vc.opponentUsername = [self.usernames objectAtIndex:tableIndex];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usernames count];
}

- (FriendsListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil){
        cell = [[FriendsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.contactName.text = [NSString stringWithFormat:@"%@", self.usernames[indexPath.row]];
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:self.friendsList[indexPath.row] forKey:@"user_id"];
    [QBRequest objectsWithClassName:@"activeSession" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        // response processing
        QBCOCustomObject *friendSession = [objects objectAtIndex:0];
        UIImage *img = [[UIImage alloc] init];
        if ((bool) [friendSession.fields objectForKey:@"online"] == true) {
            img = [UIImage imageNamed:@"greendot.png"];
            cell.contactStatus.image = img;
            NSLog(@"Made a green dot!");
        } else {
            img = [UIImage imageNamed:@"reddot.png"];
            cell.contactStatus.image = img;
            NSLog(@"Made a reddot!");
        }
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Response error: %@", [response.error description]);
    }];
    
    return cell;
}
- (IBAction)addPressed:(id)sender {
    [self performSegueWithIdentifier:@"toFR" sender:self];

}

- (IBAction)signoutPressed:(id)sender {
    NSLog(@"signing out");
    NSMutableDictionary *getSeshRequest = [NSMutableDictionary dictionary];
    [getSeshRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"user_id"];
    
    [QBRequest objectsWithClassName:@"activeSession" extendedRequest:getSeshRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        // response processing;
        QBCOCustomObject *session = [objects objectAtIndex:0];
        [session.fields setObject:@"False" forKey:@"online"];
        [QBRequest updateObject:session successBlock:^(QBResponse *response, QBCOCustomObject *session) {
            // object updated
            NSLog(@"Seemed to have updated the sesh sucessfully!");
            //NSLog(@"%lu", (unsigned long)session.userID);
            
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Could not update custom object. Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"No object found when searching for custom object. Response error: %@", [response.error description]);
    }];

    if([[QBChat instance] isLoggedIn]){
        [[QBChat instance] logout];
    }
    [self performSegueWithIdentifier:@"backToLogin" sender:self];
}
@end
