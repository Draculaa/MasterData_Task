//
//  Photo.m
//  MasterData_Task
//
//  Created by Евгений on 15.12.15.
//  Copyright © 2015 Eugene Kirtaev. All rights reserved.
//

#import "Photo.h"
#import <DateTools.h>

@implementation Photo

- (instancetype)initWithMediaId: (NSString *) mediaId andURL: (NSURL *) url{
    
    self = [super init];
    if (self) {
        self.mediaId = mediaId;
        self.url = url;
    }else{
        return nil;
    }
    return self;
}

-(instancetype)initDetailWithServerResponse:(NSDictionary *)responseObject{
    self = [super init];
    if (self) {
        NSDictionary * data = responseObject[@"data"];
        NSString * mediaId = data[@"id"];
        NSString * urlString = data[@"images"][@"standard_resolution"][@"url"];
        NSURL * url = [NSURL URLWithString:urlString];
        self.mediaId = mediaId;
        self.url = url;
        self.likesCount = [data[@"likes"][@"count"] integerValue];
        NSObject * caption = data[@"caption"];
        if (![caption isKindOfClass:[NSNull class]]) {
            self.caption = data[@"caption"][@"text"];
        }else{
            self.caption = @"";
        }
        double timeInterval = [data[@"created_time"] doubleValue];
        NSDate * date = [[NSDate alloc]initWithTimeIntervalSince1970:timeInterval];
        self.stringTime = date.shortTimeAgoSinceNow;
        self.userHasLiked = [data[@"user_has_liked"] boolValue];
        self.userName = data[@"user"][@"username"];
        NSString * profilePictureUrl = data[@"user"][@"profile_picture"];
        self.profilePictureUrl = [NSURL URLWithString:profilePictureUrl];
    }else{
        return nil;
    }
    return self;
}

-(instancetype)initPreviewWithServerResponse:(NSDictionary *)responseObject{
    self = [super init];
    if (self) {
        NSString * mediaId = responseObject[@"id"];
        NSString * urlString = responseObject[@"images"][@"low_resolution"][@"url"];
        NSURL * url = [NSURL URLWithString:urlString];
        self.mediaId = mediaId;
        self.url = url;
    }else{
        return nil;
    }
    return self;
}


@end
