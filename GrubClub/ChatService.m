//
//  ChatService.m
//  GrubClub
//
//  Created by Surakij Areenukul on 11/25/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import "ChatService.h"
#import <Quickblox/Quickblox.h>
#import "MainViewController.h"

typedef void(^CompletionBlock)();
typedef void(^JoinRoomCompletionBlock)(QBChatRoom *);
typedef void(^CompletionBlockWithResult)(NSArray *);

@interface ChatService () <QBChatDelegate>

@property (copy) QBUUser *currentUser;
@property (retain) NSTimer *presenceTimer;
@property (copy) CompletionBlock loginCompletionBlock;
@property UIViewController* view;
@property NSString* opponentLogin;
@property NSString* sessionID;
@property NSUInteger opponentID;
@property id<QBChatDelegate> delegate;

@end

@implementation ChatService
+ (instancetype)instance{
    static id instance_ = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] init];
    });
    
    return instance_;
}

- (id)init{
    NSLog(@"inside init");
    self = [super init];
    if(self){
        [QBChat instance].delegate = self;
    }
    return self;
}


//stephen working here
- (void) setViewController:(UIViewController *) vc{
    self.view = [[UIViewController alloc]init];
    self.view = vc;
}

- (void) accept{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainViewController *vc = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"videoScreen"];
    vc.opponentUsername = self.opponentLogin;
    vc.receivedCall = YES;
    vc.opponentID = [NSNumber numberWithInteger:self.opponentID];
    vc.videoChat = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:self.sessionID];
    [self.view presentViewController:vc animated:YES completion:NULL];
//    [self.view performSegueWithIdentifier:@"videoSegue" sender:_view];
}

- (void) reject{
    QBVideoChat *video = [[QBChat instance] createAndRegisterVideoChatInstanceWithSessionID:self.sessionID];
    [video rejectCallWithOpponentID:self.opponentID];
    [[QBChat instance] unregisterVideoChatInstance:video];
    video = nil;
    self.callAlert = nil;
}

- (void) setAlert{
    self.callAlert = nil;
}

- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock{
    self.loginCompletionBlock = completionBlock;
    
    NSLog(@"using singleton login!");
    
    self.currentUser = user;
    
    [[QBChat instance] loginWithUser:user];
}


- (void)chatDidLogin{
    // Start sending presences
    [self.presenceTimer invalidate];
    self.presenceTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                          target:[QBChat instance] selector:@selector(sendPresence)
                                                        userInfo:nil repeats:YES];
    
    if(self.loginCompletionBlock != nil){
        self.loginCompletionBlock();
        self.loginCompletionBlock = nil;
    }
}

- (void)chatDidFailWithError:(NSInteger)code{
    // relogin here
    NSLog(@"singleton login failed");
}

- (void)chatDidReceiveCallRequestFromUser:(NSUInteger)userID withSessionID:(NSString *)sessionID conferenceType:(enum QBVideoChatConferenceType)conferenceType{
    NSLog(@"broooooo");
    [QBRequest userWithID:userID successBlock:^(QBResponse *response, QBUUser *user) {
        
        
        self.opponentID = userID;
        self.sessionID = sessionID;
        
        // Successful response with user
        if (self.callAlert == nil){
            NSString *message = [NSString stringWithFormat:@"%@ is calling. Would you like to answer?", user.login];
            self.opponentLogin = user.login;
            self.callAlert = [[UIAlertView alloc] initWithTitle:@"Call" message:message delegate:self cancelButtonTitle:@"Decline" otherButtonTitles:@"Accept", nil];
            [self.callAlert show];
        }
        else{
            NSLog(@"call alert is not nil!!!");
        }
    } errorBlock:^(QBResponse *response) {
        // Handle error
    }];
}

- (void) chatCallUserDidNotAnswer:(NSUInteger)userID{
    
    NSLog(@"in chatservice chatCallUserDidNotAnswer");
    //send notification to update UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didNotAnswer" object:nil];
    
    
    //show alert that user is not responding
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QuickBlox VideoChat" message:@"User isn't answering. Please try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void) chatCallDidRejectByUser:(NSUInteger)userID{
    NSLog(@"in chatservice chatCallDidRejectByUser");
    //send notification to update UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didRejectByUser" object:nil];
    
    //show alert user rejected call
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QuickBlox VideoChat" message:@"User has rejected your call." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void) chatCallDidAcceptByUser:(NSUInteger)userID{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didAccept" object:nil];
}

-(void) chatCallDidStopByUser:(NSUInteger)userID status:(NSString *)status{
    NSLog(@"in chatservice chatCallDidStopByUser");
    NSDictionary *aDictionary = @{ @"status" : status};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didStopByUser" object:nil userInfo:aDictionary];
}

-(void) chatCallDidStartWithUser:(NSUInteger)userID sessionID:(NSString *)sessionID{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didStartWithUser" object:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
            // Reject
        case 0:
            [self reject];
            NSLog(@"reject pressed");
            break;
            // Accept
        case 1:
            NSLog(@"accept pressed");
            [self accept];
            break;
            
        default:
            break;
    }
    
    self.callAlert = nil;
}


@end
