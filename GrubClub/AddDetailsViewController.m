//
//  AddDetailsViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/9/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//
/*TODO:
 1. check if user already in friend request list
 2. check if user is already in friendlist
 3. cancel button
 */
#import "AddDetailsViewController.h"

@interface AddDetailsViewController ()
@end

@implementation AddDetailsViewController
@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *name = [NSString stringWithFormat:@"Name: %@",user.fullName];
    _label1.text = name;
    
    NSString *login = [NSString stringWithFormat:@"username: %@",user.login];
    _label2.text = login;
    // Do any additional setup after loading the view.
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

- (IBAction)addPressed:(id)sender {
    //set up request
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    [getRequest setObject:[NSNumber numberWithInt:user.ID] forKey:@"user_id"];
    

    //make request
    [QBRequest objectsWithClassName:@"FriendRequests" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
        
        
        // response processing
        NSLog(@"add worked. objects in objects array: %lu", (unsigned long)objects.count);
        QBCOCustomObject *test2 = [objects objectAtIndex:0];
        QBUUser *current = [[QBChat instance]currentUser];
        NSLog(@"Current user in AddDetails is id: %d", current.ID);
        NSNumber *status = [NSNumber numberWithInteger:current.ID];
        
        NSLog(@"adding this person to friendrequests: %@", status);
        [test2.fields setObject:status forKey:@"add_to_set[friendRequests][]"];
        [test2.fields setObject:current.login forKey:@"add_to_set[usernames][]"];
        [QBRequest updateObject:test2 successBlock:^(QBResponse *response, QBCOCustomObject *object) {
            // object updated
            //NSLog(@"SUCESS WUUUUUT");
        } errorBlock:^(QBResponse *response) {
            // error handling
            NSLog(@"Response error: %@", [response.error description]);
        }];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"Add failed, Response error: %@", [response.error description]);
    }];
}


- (IBAction)cancelPressed:(id)sender {
    [self performSegueWithIdentifier:@"cancel" sender:self];
    
}
@end