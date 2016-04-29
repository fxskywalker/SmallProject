//
//  MainViewController.m
//  SmallProject
//
//  Created by FangXin on 4/27/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import "MainViewController.h"
#import "APIManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ImageTableViewCell.h"
#import "VideoTableViewCell.h"
#import "InfoObject.h"
#import "LargeImageViewController.h"
#import "LargeVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LoginController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MainViewController {
  NSArray * tempInfo;
  NSMutableDictionary* photoStore;
  NSMutableDictionary* profileStore;
  NSMutableDictionary* videoStore;
  NSMutableDictionary* playerStore;
  UIActivityIndicatorView* indicatorFooter;
  bool loadingMoreData;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.title = @"Instagram Project";
  loadingMoreData = NO;
  photoStore = [[NSMutableDictionary alloc] init];
  profileStore = [[NSMutableDictionary alloc] init];
  videoStore = [[NSMutableDictionary alloc] init];
  playerStore = [[NSMutableDictionary alloc] init];
  LoginController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
  loginVC.mainVC = self;
  [self presentViewController:loginVC animated:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) loadingData {
  APIManager * temp = [APIManager sharedInstance];
  [[APIManager sharedInstance] getVedioAndImageLinkArray: ^(bool result) {
    tempInfo = temp.infos;
    [self.mainTableView reloadData];
  }];
  [self initializeRefreshControl];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
  if (tempInfo) {
    return [tempInfo count];
  }
  return 5;
}

- (void) removeFile:(NSURL*) url {
  NSString *path = [url path];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error;
  if ([fileManager fileExistsAtPath:path]) {
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
      BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
      if (!success) {
        NSLog(@"Error removing file at path");
      }
      else
      {
        NSLog(@"File removed  at path");
      }
    }
    else
    {
      NSLog(@"file not exists");
    }
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
  if (tempInfo) {
    if (tempInfo[indexPath.row]) {
      InfoObject * object = tempInfo[indexPath.row];
      if ([object.type isEqualToString:@"image"]) {
         LargeImageViewController *largeImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"largeimageVC"];
        if (photoStore[object.id]) {
          //make sure do UI in main queue
          dispatch_async(dispatch_get_main_queue(), ^{
            largeImageVC.largeImageView.image = photoStore[object.id];
          });
        }
        [[APIManager sharedInstance] getImageByLink:object.imageLarge withCallBack:^(NSURL* url){
          NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];

          largeImageVC.largeImageView.image = [UIImage imageWithData: imageData];
          [self removeFile:url];
        }];
        [self.navigationController pushViewController:largeImageVC animated:YES];
      } else {
        LargeVideoViewController *largeVideoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"largevideoVC"];
        [[APIManager sharedInstance] getVideoByLink: object.videoLarge withCallBack:^(NSURL* url) {
          [largeVideoVC playVideo:url];
          [self removeFile:url];
        }];
        [self.navigationController pushViewController:largeVideoVC animated:YES];
      }
    }
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tempInfo) {
    if (tempInfo[indexPath.row]) {
      InfoObject * object = tempInfo[indexPath.row];
      // show image
      if ([object.type isEqualToString:@"image"]) {
        static NSString *CellIdentifier1 = @"ImageCell";
        ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        imageCell.nameLabel.text = object.name;
        imageCell.likesLabel.text =  [@"likes: " stringByAppendingString:[@(object.like) stringValue]];
        imageCell.commentsLabel.text =  [@"comments: " stringByAppendingString:[@(object.comment) stringValue]];
        
        // prevent call API deplicate time
        if (!photoStore[object.id]) {
          [[APIManager sharedInstance] getImageByLink:object.imageNail withCallBack:^(NSURL* url){
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
            imageCell.mainPhotoImageView.image = [UIImage imageWithData: imageData];
            NSString *tempId = object.id;
            //update image
            [photoStore setObject:imageCell.mainPhotoImageView.image forKey:[tempId copy]];
            //clear storage
            [self removeFile:url];
          }];
        } else {
          imageCell.mainPhotoImageView.image = photoStore[object.id];
        }
        
        // make round profile
        imageCell.thumbnailImageView.layer.cornerRadius = imageCell.thumbnailImageView.frame.size.height / 2;
        imageCell.thumbnailImageView.layer.borderWidth = 1;
        imageCell.thumbnailImageView.layer.borderColor = [[UIColor grayColor] CGColor];
        CALayer *imageLayer = imageCell.thumbnailImageView.layer;
        imageLayer.cornerRadius = 0.5 * imageCell.thumbnailImageView.frame.size.width;
        imageLayer.masksToBounds = YES;
        
        // prevent call API deplicate time
        if (! profileStore[object.name]) {
          [[APIManager sharedInstance] getImageByLink:object.userProfile withCallBack:^(NSURL* url) {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
            imageCell.thumbnailImageView.image = [UIImage imageWithData: imageData];
            [profileStore setObject:imageCell.thumbnailImageView.image forKey:[object.name copy]];
          }];
        } else {
          imageCell.thumbnailImageView.image = profileStore[object.name];
        }
        return imageCell;
      // show video
      } else {
        static NSString *CellIdentifier2 = @"VideoCell";
        VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
        videoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        videoCell.nameLabel.text = object.name;
        videoCell.likesLabel.text =  [@"likes: " stringByAppendingString:[@(object.like) stringValue]];
        videoCell.commentsLabel.text =  [@"comments: " stringByAppendingString:[@(object.comment) stringValue]];
        
       
        if (!videoStore[object.id]) {
          [[APIManager sharedInstance] getVideoByLink: object.videoNail withCallBack:^(NSURL* url) {
            AVPlayer * avPlayer = [AVPlayer playerWithURL:url];
            AVPlayerLayer* avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
            avPlayerLayer.frame = videoCell.videoView.layer.bounds;
            avPlayerLayer.videoGravity = AVLayerVideoGravityResize;
            [videoCell.videoView.layer addSublayer: avPlayerLayer];
            avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:[avPlayer currentItem]];
            if([self.mainTableView.indexPathsForVisibleRows containsObject:indexPath]) {
              [avPlayer play];
            }
            [playerStore setObject:avPlayer forKey:indexPath];
            [videoStore setObject:url forKey:[object.id copy]];
          }];
        } else {
          AVPlayer* tempPlayer = (AVPlayer *)playerStore[indexPath];
          AVPlayerLayer* avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:tempPlayer];
          avPlayerLayer.frame = videoCell.videoView.layer.bounds;
          avPlayerLayer.videoGravity = AVLayerVideoGravityResize;
          [videoCell.videoView.layer addSublayer: avPlayerLayer];
          [tempPlayer play];
        }

        // make round profile
        videoCell.thumbnailImageView.layer.cornerRadius = videoCell.thumbnailImageView.frame.size.height / 2;
        videoCell.thumbnailImageView.layer.borderWidth = 1;
        videoCell.thumbnailImageView.layer.borderColor = [[UIColor grayColor] CGColor];
        CALayer *videoLayer = videoCell.thumbnailImageView.layer;
        videoLayer.cornerRadius = 0.5 * videoCell.thumbnailImageView.frame.size.width;
        videoLayer.masksToBounds = YES;
        
        if (! profileStore[object.name]) {
          [[APIManager sharedInstance] getImageByLink:object.userProfile withCallBack:^(NSURL* url) {
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
            videoCell.thumbnailImageView.image = [UIImage imageWithData: imageData];
            [profileStore setObject:videoCell.thumbnailImageView.image forKey:[object.name copy]];
          }];
        } else {
          videoCell.thumbnailImageView.image = profileStore[object.name];
        }
        return videoCell;
      }
    } else {
      static NSString *CellIdentifier1 = @"ImageCell";
      ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
      return imageCell;
    }
  } else {
    static NSString *CellIdentifier1 = @"ImageCell";
    ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    return imageCell;
  }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (playerStore[indexPath]) {
      [(AVPlayer *)playerStore[indexPath] pause];
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
  AVPlayerItem *item = [notification object];
  [item seekToTime:kCMTimeZero];
}

-(void)initializeRefreshControl
{
  indicatorFooter = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.mainTableView.frame), 44)];
  [indicatorFooter setColor:[UIColor blackColor]];
  
  [self.mainTableView setTableFooterView:indicatorFooter];
}

-(void)refreshTableVeiwList
{
  [indicatorFooter startAnimating];
  APIManager * temp = [APIManager sharedInstance];
  [[APIManager sharedInstance] getVedioAndImageLinkArray: ^(bool result) {
    if (result) {
      tempInfo = temp.infos;
      [self.mainTableView reloadData];
      loadingMoreData = NO;
    }
    [indicatorFooter stopAnimating];
  }];
}
-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
  if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height)
  {
    if (!loadingMoreData)
    {
      loadingMoreData = YES;
      
      [self refreshTableVeiwList];
    }
    
  }
}

@end
