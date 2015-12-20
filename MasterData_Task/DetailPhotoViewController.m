//
//  DetailPhotoViewController.m
//  MasterData_Task
//
//  Created by Евгений on 15.12.15.
//  Copyright © 2015 Eugene Kirtaev. All rights reserved.
//

#import "DetailPhotoViewController.h"
#import <UIImageView+AFNetworking.h>
#import "ServerManager.h"

@interface DetailPhotoViewController ()

@property (strong, nonatomic) Photo * object;

@end

@implementation DetailPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarImageView.layer.cornerRadius = 25.0;
    self.avatarImageView.clipsToBounds = YES;
    [self getDetailPhoto];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDetailPhoto{
    __weak typeof(self) wSelf = self;
    [[ServerManager sharedManager] getDetailPhotoWithMediaID:self.mediaId
                                                   OnSuccess:^(Photo *photo) {
                                                       wSelf.object = photo;
                                                       [self reloadView];
                                                   } onFailure:^(NSError *error, NSInteger *statusCode) {
                                                       NSLog(@"%@", [error localizedDescription]);
                                                   }];
}

- (void)reloadView{
    self.usernameLabel.text = self.object.userName;
    [self.avatarImageView setImageWithURL:self.object.profilePictureUrl];
    [self.photoImageView setImageWithURL:self.object.url
                        placeholderImage:[UIImage imageNamed:@"No-image-found"]];
    self.countlikesLabel.text = [NSString stringWithFormat:@"%d", self.object.likesCount];
    self.captionLabel.text = self.object.caption;
    self.timeLabel.text = self.object.stringTime;
    if (self.object.userHasLiked) {
        [self.heartImageView setImage:[UIImage imageNamed:@"heart_red"]];
    } else {
        [self.heartImageView setImage:[UIImage imageNamed:@"heart_white"]];
    }
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
