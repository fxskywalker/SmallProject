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

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MainViewController {
  NSArray * tempInfo;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  self.title = @"Instagram Project";
  APIManager * temp = [APIManager sharedInstance];
  [[APIManager sharedInstance] getVedioAndImageLinkArray: ^(bool result) {
    tempInfo = temp.infos;
    [self.mainTableView reloadData];
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tempInfo) {
    if (tempInfo[indexPath.row]) {
      InfoObject * object = tempInfo[indexPath.row];
      NSLog(@"%ld",(long)indexPath.item);
      // show image
      if ([object.type isEqualToString:@"image"]) {
        static NSString *CellIdentifier1 = @"ImageCell";
        ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        [[APIManager sharedInstance] getImageByLink:object.imageNail withCallBack:^(NSURL* url){
          NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
          imageCell.mainPhotoImageView.image = [UIImage imageWithData: imageData];
        }];
        [[APIManager sharedInstance] getImageByLink:object.userProfile withCallBack:^(NSURL* url){
          NSData * imageData = [[NSData alloc] initWithContentsOfURL: url];
          imageCell.thumbnailImageView.layer.cornerRadius = imageCell.thumbnailImageView.frame.size.height / 2;
          imageCell.thumbnailImageView.layer.borderWidth = 1;
          imageCell.thumbnailImageView.layer.borderColor = [[UIColor grayColor] CGColor];
          CALayer *imageLayer = imageCell.thumbnailImageView.layer;
          imageLayer.cornerRadius = 0.5 * imageCell.thumbnailImageView.frame.size.width;
          imageLayer.masksToBounds = YES;
          imageCell.thumbnailImageView.image = [UIImage imageWithData: imageData];
        }];
        return imageCell;
        // show video
      } else {
        static NSString *CellIdentifier1 = @"ImageCell";
        //static NSString *CellIdentifier2 = @"VideoCell";
        ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
        //  VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
        return imageCell;
      }
    } else {
      static NSString *CellIdentifier1 = @"ImageCell";
      //static NSString *CellIdentifier2 = @"VideoCell";
      ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
      //  VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
      return imageCell;
    }
  } else {
    static NSString *CellIdentifier1 = @"ImageCell";
    //static NSString *CellIdentifier2 = @"VideoCell";
    ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    //  VideoTableViewCell *videoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2 forIndexPath:indexPath];
    return imageCell;
  }
}

@end
