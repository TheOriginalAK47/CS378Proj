//
//  ViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 10/18/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* Testing whether or not app is communicating with SDK 8? */
    /*  A new object of class TestObject will be sent to the Parse Cloud and saved */
    /* https://www.parse.com/apps/quickstart#parse_data/mobile/ios/native/existing */
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
