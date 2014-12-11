//
//  SplashViewController.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/9/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "SplashViewController.h"
#import <Quickblox/Quickblox.h>

@interface SplashViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SplashViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Your app connects to QuickBlox server here.
    //
    // QuickBlox session creation
    [self.activityIndicator startAnimating];
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        [self performSelector:@selector(hideSplash) withObject:nil afterDelay:2];
    } errorBlock:^(QBResponse *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                        message:[response.error description]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", "")
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)hideSplash
{
    [self performSegueWithIdentifier:@"MainViewControllerSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.activityIndicator stopAnimating];
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
