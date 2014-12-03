//
//  MainViewController.m
//  SimpleSample-videochat-ios
//
//  Created by QuickBlox team on 1/02/13.
//  Copyright (c) 2013 QuickBlox. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "ChatService.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize opponentID;
@synthesize curUser;
@synthesize opponentUsername;
@synthesize receivedCall;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view bringSubviewToFront:myVideoView];
    
    //testing notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationHandler:) name:@"didNotAnswer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationHandler:) name:@"didRejectByUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationHandler:) name:@"didAccept" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationHandler:) name:@"didStopByUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myNotificationHandler:) name:@"didStartWithUser" object:nil];
    
    
    [[ChatService instance] setViewController:self];
    curUser = [[QBChat instance] currentUser];
    opponentVideoView.layer.borderWidth = 1;
    opponentVideoView.layer.borderColor = [[UIColor grayColor] CGColor];
    opponentVideoView.layer.cornerRadius = 5;
    NSLog(@"MainViewcontroller current user: %@", curUser.login);
    NSLog(@"MainViewcontroller opponent user: %@", opponentUsername);
    
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    navBar.topItem.title = curUser.login;
    [callButton setTitle:@"Call" forState:UIControlStateNormal];
    
    if(!QB_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")){
        audioOutput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        audioOutput.frame = CGRectMake(audioOutput.frame.origin.x-15, audioOutput.frame.origin.y, audioOutput.frame.size.width+50, audioOutput.frame.size.height);
        videoOutput.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    }
    
    if (receivedCall == YES){
        self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
        self.videoChat.viewToRenderOwnVideoStream = myVideoView;
        
        // Set Audio & Video output
        //
        self.videoChat.useHeadphone = audioOutput.selectedSegmentIndex;
        self.videoChat.useBackCamera = videoOutput.selectedSegmentIndex;
        
        // Handles accept call
        //
        [self.videoChat acceptCallWithOpponentID:[opponentID integerValue] conferenceType:QBVideoChatConferenceTypeAudioAndVideo];
        
        ringigngLabel.hidden = YES;
        callButton.hidden = NO;
        [callButton setTitle:@"Hang up" forState:UIControlStateNormal];
        callButton.tag = 102;
        
        opponentVideoView.layer.borderWidth = 0;
        
        [startingCallActivityIndicator startAnimating];
        
        myVideoView.hidden = NO;
        opponentVideoView.hidden = NO;
        
        ringingPlayer = nil;
    }
}

//testing notifications
- (void) myNotificationHandler:(NSNotification *)notification
{
    NSLog(@"in notificationhandler");
    NSString* notificationName = notification.name;
    if ([notificationName isEqualToString:@"didNotAnswer"]){
        NSLog(@"this is first notification handler");
        callButton.hidden = NO;
        ringigngLabel.hidden = YES;
        callingActivityIndicator.hidden = YES;
        callButton.tag = 101;
    }
    else if ([notificationName isEqualToString:@"didRejectByUser"]){
        NSLog(@"this is second notification handler");
        callButton.hidden = NO;
        ringigngLabel.hidden = YES;
        callingActivityIndicator.hidden = YES;
        
        callButton.tag = 101;
    }
    else if ([notificationName isEqualToString:@"didAccept"]){
        NSLog(@"this is third notification handler");
        ringigngLabel.hidden = YES;
        callingActivityIndicator.hidden = YES;
        
        opponentVideoView.layer.borderWidth = 0;
        
        callButton.hidden = NO;
        [callButton setTitle:@"Hang up" forState:UIControlStateNormal];
        callButton.tag = 102;
        
        myVideoView.hidden = NO;
        opponentVideoView.hidden = NO;
        
        [startingCallActivityIndicator startAnimating];
    }
    else if ([notificationName isEqualToString:@"didStartWithUser"]){
        NSLog(@"this is fourth notification handler");
        [startingCallActivityIndicator stopAnimating];
    }
    else if ([notificationName isEqualToString:@"didStopByUser"]){
        NSLog(@"this is fifth notification handler");
        NSDictionary *dict = [notification userInfo];
        //retrieve strings from dict
        NSString *status = [dict objectForKey:@"status"];
        
        
        if([status isEqualToString:kStopVideoChatCallStatus_OpponentDidNotAnswer]){
            
            self.callAlert.delegate = nil;
            [self.callAlert dismissWithClickedButtonIndex:0 animated:YES];
            self.callAlert = nil;
            
            ringigngLabel.hidden = YES;
            
            ringingPlayer = nil;
            
        }else{
            NSLog(@"we are here stephen");
            myVideoView.hidden = YES;
            opponentVideoView.hidden = YES;
            //opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
            opponentVideoView.layer.borderWidth = 1;
            //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [callButton setTitle:@"Call" forState:UIControlStateNormal];
            callButton.tag = 101;
        }
        
        callButton.hidden = NO;
        
        // release video chat
        //
        [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
        self.videoChat = nil;
    }
    
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)audioOutputDidChange:(UISegmentedControl *)sender{
    if(self.videoChat != nil){
        self.videoChat.useHeadphone = sender.selectedSegmentIndex;
    }
}

- (IBAction)videoOutputDidChange:(UISegmentedControl *)sender{
    if(self.videoChat != nil){
        self.videoChat.useBackCamera = sender.selectedSegmentIndex;
    }
}

- (IBAction)call:(id)sender{
    if(callButton.tag == 101){
        callButton.tag = 102;
        
        // Call
        
        // Setup video chat
        //
        if(self.videoChat == nil){
            
            self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstance];
            self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
            self.videoChat.viewToRenderOwnVideoStream = myVideoView;
        }
        
        // Set Audio & Video output
        //
        self.videoChat.useHeadphone = audioOutput.selectedSegmentIndex;
        self.videoChat.useBackCamera = videoOutput.selectedSegmentIndex;
        
        // Call user by ID
        //
        [self.videoChat callUser:[opponentID integerValue] conferenceType:QBVideoChatConferenceTypeAudioAndVideo];
        
        callButton.hidden = YES;
        ringigngLabel.hidden = NO;
        ringigngLabel.text = @"Calling...";
        ringigngLabel.frame = CGRectMake(128, 375, 90, 37);
        callingActivityIndicator.hidden = NO;
        // Finish
    }else{
        callButton.tag = 101;
        
        // Finish call
        //
        [self.videoChat finishCall];
        opponentVideoView.hidden = YES;
        myVideoView.hidden = YES;
        //opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
        //opponentVideoView.image = [UIImage imageNamed:@"person.png"];
        [callButton setTitle:@"Call" forState:UIControlStateNormal];
        
        opponentVideoView.layer.borderWidth = 1;
        
        [startingCallActivityIndicator stopAnimating];
        
        
        // release video chat
        //
        [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
        self.videoChat = nil;
    }
}

- (void)reject{
    // Reject call
    //
    if(self.videoChat == nil){
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:sessionID];
    }
    [self.videoChat rejectCallWithOpponentID:videoChatOpponentID];
    //
    //
    [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
    self.videoChat = nil;

    // update UI
    callButton.hidden = NO;
    ringigngLabel.hidden = YES;
    
    // release player
    ringingPlayer = nil;
}

- (void)accept{
    NSLog(@"accept");
    // Setup video chat
    //
    if(self.videoChat == nil){
        self.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:sessionID];
        self.videoChat.viewToRenderOpponentVideoStream = opponentVideoView;
        self.videoChat.viewToRenderOwnVideoStream = myVideoView;
    }
    
    // Set Audio & Video output
    //
    self.videoChat.useHeadphone = audioOutput.selectedSegmentIndex;
    self.videoChat.useBackCamera = videoOutput.selectedSegmentIndex;
    
    // Accept call
    //
    [self.videoChat acceptCallWithOpponentID:videoChatOpponentID conferenceType:QBVideoChatConferenceTypeAudioAndVideo];
    [[ChatService instance] setAlert];

    ringigngLabel.hidden = YES;
    callButton.hidden = NO;
    [callButton setTitle:@"Hang up" forState:UIControlStateNormal];
    callButton.tag = 102;
    
    opponentVideoView.layer.borderWidth = 0;
    
    [startingCallActivityIndicator startAnimating];
    
     myVideoView.hidden = NO;
    opponentVideoView.hidden = NO;
    
    ringingPlayer = nil;
}

- (void)hideCallAlert{
    [self.callAlert dismissWithClickedButtonIndex:-1 animated:YES];
    self.callAlert = nil;
    
    callButton.hidden = NO;
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    ringingPlayer = nil;
}


#pragma mark -
#pragma mark QBChatDelegate 
//
// VideoChat delegate

//-(void) chatDidReceiveCallRequestFromUser:(NSUInteger)userID withSessionID:(NSString *)_sessionID conferenceType:(enum QBVideoChatConferenceType)conferenceType{
//    NSLog(@"chatDidReceiveCallRequestFromUser %lu", (unsigned long)userID);
//    
//    // save  opponent data
//    videoChatOpponentID = [opponentID integerValue];
//    videoChatConferenceType = conferenceType;
//    sessionID = _sessionID;
//    
//    
//    callButton.hidden = YES;
//    
//    // show call alert
//    //
//    if (self.callAlert == nil) {
//        //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        NSString *message = [NSString stringWithFormat:@"%@ is calling. Would you like to answer?", opponentUsername];
//        self.callAlert = [[UIAlertView alloc] initWithTitle:@"Call" message:message delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
//        [self.callAlert show];
//    }
//    
//    // hide call alert if opponent has canceled call
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideCallAlert) object:nil];
//    [self performSelector:@selector(hideCallAlert) withObject:nil afterDelay:4];
//    
//    // play call music
//    //
////    if(ringingPlayer == nil){
////        NSString *path =[[NSBundle mainBundle] pathForResource:@"ringing" ofType:@"wav"];
////        NSURL *url = [NSURL fileURLWithPath:path];
////        ringingPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
////        ringingPlayer.delegate = self;
////        [ringingPlayer setVolume:1.0];
////        [ringingPlayer play];
////    }
//}

//-(void) chatCallUserDidNotAnswer:(NSUInteger)userID{
//    NSLog(@"chatCallUserDidNotAnswer %lu", (unsigned long)userID);
//    
//    callButton.hidden = NO;
//    ringigngLabel.hidden = YES;
//    callingActivityIndicator.hidden = YES;
//    callButton.tag = 101;
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QuickBlox VideoChat" message:@"User isn't answering. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alert show];
//}

//-(void) chatCallDidRejectByUser:(NSUInteger)userID{
//     NSLog(@"chatCallDidRejectByUser %lu", (unsigned long)userID);
//    
//    callButton.hidden = NO;
//    ringigngLabel.hidden = YES;
//    callingActivityIndicator.hidden = YES;
//    
//    callButton.tag = 101;
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QuickBlox VideoChat" message:@"User has rejected your call." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alert show];
//}
//
//-(void) chatCallDidAcceptByUser:(NSUInteger)userID{
//    NSLog(@"chatCallDidAcceptByUser %lu", (unsigned long)userID);
//    
//    ringigngLabel.hidden = YES;
//    callingActivityIndicator.hidden = YES;
//    
//    opponentVideoView.layer.borderWidth = 0;
//    
//    callButton.hidden = NO;
//    [callButton setTitle:@"Hang up" forState:UIControlStateNormal];
//    callButton.tag = 102;
//    
//     myVideoView.hidden = NO;
//    opponentVideoView.hidden = NO;
//    
//    [startingCallActivityIndicator startAnimating];
//}
//
//-(void) chatCallDidStopByUser:(NSUInteger)userID status:(NSString *)status{
//    NSLog(@"chatCallDidStopByUser %lu purpose %@", (unsigned long)userID, status);
//    
//    if([status isEqualToString:kStopVideoChatCallStatus_OpponentDidNotAnswer]){
//        
//        self.callAlert.delegate = nil;
//        [self.callAlert dismissWithClickedButtonIndex:0 animated:YES];
//        self.callAlert = nil;
//     
//        ringigngLabel.hidden = YES;
//        
//        ringingPlayer = nil;
//    
//    }else{
//        myVideoView.hidden = YES;
//        opponentVideoView.hidden = YES;
//        //opponentVideoView.layer.contents = (id)[[UIImage imageNamed:@"person.png"] CGImage];
//        opponentVideoView.layer.borderWidth = 1;
//        //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [callButton setTitle:curUser.fullName forState:UIControlStateNormal];
//        callButton.tag = 101;
//    }
//    
//    callButton.hidden = NO;
//    
//    // release video chat
//    //
//    [[QBChat instance] unregisterVideoChatInstance:self.videoChat];
//    self.videoChat = nil;
//}
//
//- (void)chatCallDidStartWithUser:(NSUInteger)userID sessionID:(NSString *)sessionID{
//    [startingCallActivityIndicator stopAnimating];
//}

//- (void)didStartUseTURNForVideoChat{
////    NSLog(@"_____TURN_____TURN_____");
//}


#pragma mark -
#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        // Reject
        case 0:
            [self reject];
            break;
        // Accept
        case 1:
            [self accept];
            break;
            
        default:
            break;
    }
    
    self.callAlert = nil;
}

@end
