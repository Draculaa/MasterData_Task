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
@property (strong, nonatomic) NSString * comment;

@end
