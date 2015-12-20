//
//  Photo.h
//  MasterData_Task
//
//  Created by Евгений on 15.12.15.
//  Copyright © 2015 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSURL * url;
@property NSInteger likesCount;
@property (strong, nonatomic) NSString * caption;
@property BOOL userHasLiked;
@property (strong, nonatomic) NSString * mediaId;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * stringTime;
@property (strong, nonatomic) NSURL * profilePictureUrl;

//- (instancetype)initWithMediaId: (NSString *) mediaId andURL: (NSURL *) url;
- (instancetype)initPreviewWithServerResponse: (NSDictionary *)responseObject;
- (instancetype)initDetailWithServerResponse: (NSDictionary *)responseObject;

@end
