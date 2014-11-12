//
//  FLViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/12/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "FLViewController.h"

@interface FLViewController ()
- (IBAction)signoutPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addPressed:(id)sender;
@end

@implementation FLViewController
@synthesize currentUser;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"friendslist viewcontroller called");
    // Do any additional setup after loading the view.
    
    self.friendsList = [[NSMutableArray alloc] init];
    self.usernames = [[NSMutableArray alloc] init];
    currentUser = [[QBChat instance] currentUser];
    
    
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"user_id"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.usernames count];
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.usernames[indexPath.row]];
    return cell;
}
- (IBAction)addPressed:(id)sender {
    [self performSegueWithIdentifier:@"toFR" sender:self];

}
- (IBAction)signoutPressed:(id)sender {
}
@end
