//
//  ServerManager.m
//  MasterData_Task
//
//  Created by Евгений on 19.12.15.
//  Copyright © 2015 Eugene Kirtaev. All rights reserved.
//

#import "ServerManager.h"
#import <AFNetworking.h>

@interface ServerManager ()

@property (strong, nonatomic) NSString * accesToken;
@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) AFHTTPSessionManager * httpSessionManager;
@property (strong, nonatomic) NSURLSessionTask * datatask;
@property (strong, nonatomic) NSString * nextMaxId;

@end
static NSString * count = @"12";

@implementation ServerManager

+ (instancetype)sharedManager{
    static ServerManager * server = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[ServerManager alloc]init];
    });
    return server;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSURL* baseURL = [NSURL URLWithString:@"https://api.instagram.com"];
        self.httpSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseURL];
        self.nextMaxId = nil;
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSString * token = [userDefaults objectForKey:@"accesToken"];
        if (token) {
            self.accesToken = token;
            self.userId = [userDefaults objectForKey:@"userID"];
        }
    }
    return self;
}

- (void)getFeedOnSuccess:(void (^)(NSArray *))succes
              onFailure:(void (^)(NSError *, NSInteger *))failure{
    NSDictionary * parameters;
    if (self.nextMaxId) {
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys: self.accesToken, @"access_token", count, @"count", self.nextMaxId, @"max_id", nil];
    }else{
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys: self.accesToken, @"access_token", count, @"count", nil];
    }
    
    self.datatask = [self.httpSessionManager GET:[NSString stringWithFormat:@"/v1/users/self/media/recent"]
                                      parameters:parameters
                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                             NSLog(@"%@", responseObject);
                                             NSDictionary * data = responseObject[@"data"];
                                             NSMutableArray * photoObjects = [NSMutableArray new];
                                             for (NSDictionary * photoDesc in data) {
                                                 Photo * photo = [[Photo alloc] initPreviewWithServerResponse:photoDesc];
                                                 [photoObjects addObject:photo];
                                             }
                                             self.nextMaxId = responseObject[@"pagination"][@"next_max_id"];
                                             succes(photoObjects);
                                         }
                                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                             NSLog(@"%@", error);
                                             NSInteger * code = nil;
//                                             code = (int)task.response[@"meta"][@"code"];
                                             failure(error, code);

                                         }];
    [self.datatask resume];

}

- (void)getDetailPhotoWithMediaID:(NSString *) mediaId
                        OnSuccess: (void(^)(Photo * photo)) succes
                        onFailure: (void(^)(NSError * error, NSInteger * statusCode)) failure{
    NSDictionary * parameters = [[NSDictionary alloc] initWithObjectsAndKeys: self.accesToken, @"access_token", nil];
    self.datatask = [self.httpSessionManager GET:[NSString stringWithFormat:@"/v1/media/%@", mediaId]
                                      parameters:parameters
                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                             NSLog(@"%@", responseObject);
                                             Photo * photo = [[Photo alloc] initDetailWithServerResponse:responseObject];
                                             succes(photo);
                                         }
                                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                             NSLog(@"%@", error);
                                             NSInteger * code = nil;
//                                             code = (int)task.response[@"meta"][@"code"];
                                             failure(error, code);
                                         }];
    [self.datatask resume];
}

- (void)cancel{
    [self.datatask cancel];
}

- (BOOL)isLoading{
    return self.datatask && self.datatask.state == NSURLSessionTaskStateRunning;
}

- (void)like{
    NSDictionary * parameters = [[NSDictionary alloc] initWithObjectsAndKeys: self.accesToken, @"access_token", nil];
    self.datatask = [self.httpSessionManager POST:[NSString stringWithFormat:@"/v1/media/%@/likes", @"771139564625485309_36264118"]
                                       parameters:parameters
                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                              NSLog(@"%@", responseObject);
                                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                              NSLog(@"%@", error);
                                          }];
    [self.datatask resume];
}

- (void)dislike{
    NSDictionary * parameters = [[NSDictionary alloc] initWithObjectsAndKeys: self.accesToken, @"access_token", nil];
    self.datatask = [self.httpSessionManager DELETE:[NSString stringWithFormat:@"/v1/media/%@/likes", @"771139564625485309_36264118"]
                                         parameters:parameters
                                            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                                                NSLog(@"%@", responseObject);
                                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                NSLog(@"%@", error);
                                            }];
    [self.datatask resume];
}

@end
