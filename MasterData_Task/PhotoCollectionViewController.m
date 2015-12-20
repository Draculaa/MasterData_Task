//
//  PhotoCollectionViewController.m
//  MasterData_Task
//
//  Created by Евгений on 15.12.15.
//  Copyright © 2015 Eugene Kirtaev. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "DetailPhotoViewController.h"
#import "Photo.h"
#import <SimpleAuth.h>
#import <AFNetworking/AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "ServerManager.h"

@interface PhotoCollectionViewController ()

@property (strong, nonatomic) NSMutableArray * objects;
@property (strong, nonatomic) NSString * accesToken;
@property (strong, nonatomic) NSString * userId;
@property BOOL loadingMoreData;

@end

const CGFloat paddings = 32.0;
const CGFloat numberOfItemsPerRow = 3.0;
const CGFloat heightAdjustment = 30.0;

@implementation PhotoCollectionViewController

static NSString * const reuseIdentifier = @"FeedPhotoCell";

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.objects = [NSMutableArray new];
        self.loadingMoreData = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    CGFloat width = (CGRectGetWidth(self.collectionView.frame) - paddings)/numberOfItemsPerRow;
    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(width, width + heightAdjustment);
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.backgroundColor = [UIColor whiteColor];
//    self.refreshControl.tintColor = [UIColor grayColor];
//    [self.refreshControl addTarget:self
//                            action:@selector(getLatestLoads)
//                  forControlEvents:UIControlEventValueChanged];
//    [self.collectionView addSubview:self.refreshControl];
    
    [self authInstagram];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
    {
        if (!self.loadingMoreData && self.accesToken)
        {
            [self getFeed];
        }
    }
}

//-(void)getLatestLoads{
//    [self.refreshControl beginRefreshing];
//    [self getFeed];
//    [self.refreshControl endRefreshing];
//}

- (void)authInstagram{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * token = [userDefaults objectForKey:@"accesToken"];
    if (token) {
        self.accesToken = token;
        self.userId = [userDefaults objectForKey:@"userID"];
        [self getFeed];
    }else{
        [SimpleAuth authorize:@"instagram"
                   completion:^(id responseObject, NSError *error) {
                       NSLog(@"%@", responseObject);
                       NSDictionary * credentials = responseObject[@"credentials"];
                       NSString * accessToken = credentials[@"token"];
                       NSString * userID = responseObject[@"uid"];
                       
                       [userDefaults setObject:accessToken
                                        forKey:@"accesToken"];
                       [userDefaults setObject:userID
                                        forKey:@"userID"];
                       self.accesToken = accessToken;
                       self.userId = userID;
                       [self getFeed];
                   }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getFeed{
    self.loadingMoreData = YES;
    __weak typeof(self) wSelf = self;
    [[ServerManager sharedManager] getFeedOnSuccess:^(NSArray *photos) {
        [wSelf.objects addObjectsFromArray:photos];
        [wSelf.collectionView reloadData];
         wSelf.loadingMoreData = NO;
    } onFailure:^(NSError *error, NSInteger *statusCode) {
        NSLog(@"ERROR: %@", [error localizedDescription]);
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PhotoCollectionViewCell * cell = (PhotoCollectionViewCell *)sender;
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    DetailPhotoViewController * controller = [segue destinationViewController];
    Photo * photo = [self.objects objectAtIndex:indexPath.row];
    controller.mediaId = photo.mediaId;
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return self.objects.count;
    return [self.objects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PhotoCollectionViewCell alloc] init];
    }
    Photo * photo = (Photo *)[self.objects objectAtIndex:indexPath.row];
    [cell.photoImageView setImageWithURL:photo.url
                        placeholderImage:[UIImage imageNamed:@"No-image-found"]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
