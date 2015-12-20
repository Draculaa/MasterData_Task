//
//  DetailPhotoViewController.h
//  MasterData_Task
//
//  Created by Евгений on 15.12.15.
//  Copyright © 2015 Eugene Kirtaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailPhotoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *countlikesLabel;
@property (strong, nonatomic) IBOutlet NSString *mediaId;
@property (strong, nonatomic) IBOutlet UIImageView *heartImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
