//
//  ChatService.h
//  GrubClub
//
//  Created by Surakij Areenukul on 11/25/14.
//  Copyright (c) 2014 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quickblox/Quickblox.h>

@interface ChatService : NSObject
@property UIAlertView *callAlert;
+ (instancetype)instance;
- (void) setViewController:(UIViewController *) vc;
- (void)loginWithUser:(QBUUser *)user completionBlock:(void(^)())completionBlock;

- (void) setAlert;

@end
