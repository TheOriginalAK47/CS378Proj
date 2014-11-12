//
//  RequestDetailsViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/12/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "RequestDetailsViewController.h"
#import <Quickblox/Quickblox.h>
@interface RequestDetailsViewController ()

@end

@implementation RequestDetailsViewController
@synthesize userID;
@synthesize selectedIndex;
@synthesize otherID;
@synthesize otherUsername;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [QBRequest userWithID:userID successBlock:^(QBResponse *response, QBUUser *user) {
        // Successful response with user
        NSLog(@"retrieved user successfully");
        
        NSString *name = [NSString stringWithFormat:@"Name: %@",user.fullName];
        NSString *username = [NSString stringWithFormat:@"Username: %@",user.login];
        _nameLabel.text = name;
        _usernameLabel.text = username;
    } errorBlock:^(QBResponse *response) {
        // Handle error
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

- (IBAction)acceptPressed:(id)sender {
    NSMutableDictionary *getRequest = [NSMutableDictionary dictionary];
    QBUUser *currentUser = [[QBChat instance] currentUser];
    [getRequest setObject:[NSNumber numberWithInt:currentUser.ID] forKey:@"user_id"];
    
    
    //get friendslist
    
//    [QBRequest objectsWithClassName:@"FriendsList" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
//        // response processing
//        
//        //get the list itself
//        QBCOCustomObject *test2 = [objects objectAtIndex:0];
//        NSNumber *status = [NSNumber numberWithInteger:currentUser.ID];
//        [test2.fields setObject:status forKey:@"add_to_set[friendsList][]"];
//        [test2.fields setObject:currentUser.login forKey:@"add_to_set[usernames][]"];
//    } errorBlock:^(QBResponse *response) {
//        // error handling
//        NSLog(@"Response error: %@", [response.error description]);
//    }];
    
////    remove from requests
//    [QBRequest objectsWithClassName:@"FriendRequests" extendedRequest:getRequest successBlock:^(QBResponse *response, NSArray *objects, QBResponsePage *page) {
//        // response processing
//        
//        //get the list itself
//        QBCOCustomObject *test2 = [objects objectAtIndex:0];
//        NSNumber *status = [NSNumber numberWithInteger:currentUser.ID];
//        NSLog(@"Otherusername is: %@",otherUsername);
//        [test2.fields setObject:otherID forKey:@"pull[friendRequests][]"];
//        [test2.fields setObject:otherUsername forKey:@"pul[usernames][]"];
//        [QBRequest updateObject:test2 successBlock:^(QBResponse *response, QBCOCustomObject *object) {
//            // object updated
//            NSLog(@"SUCESS WUUUUUT");
//        } errorBlock:^(QBResponse *response) {
//            // error handling
//            NSLog(@"Response error: %@", [response.error description]);
//        }];
//
//    } errorBlock:^(QBResponse *response) {
//        // error handling
//        NSLog(@"Response error: %@", [response.error description]);
//    }];
//    
//    
    
    
}

- (IBAction)declinePressed:(id)sender {
}
@end
