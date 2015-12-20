//
//  ServerManager.h
//  MasterData_Task
//
//  Created by Евгений on 19.12.15.
//  Copyright © 2015 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

@interface ServerManager : NSObject

+ (instancetype)sharedManager;
- (void)getFeedOnSuccess: (void(^)(NSArray * photos)) succes
               onFailure: (void(^)(NSError * error, NSInteger * statusCode)) failure;
- (void)getDetailPhotoWithMediaID:(NSString *) mediaId
                        OnSuccess: (void(^)(Photo * photo)) succes
                      onFailure: (void(^)(NSError * error, NSInteger * statusCode)) failure;
-(void)cancel;
-(BOOL)isLoading;

@end
