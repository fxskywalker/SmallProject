//
//  NSObject+InfoObject.h
//  SmallProject
//
//  Created by FangXin on 4/28/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoObject : NSObject
{
  NSString * id;
  NSString * type;
  NSString * imageNail;
  NSString * imageLarge;
  NSString * videoNail;
  NSString * videoLarge;
  NSString * userProfile;
  NSString * name;
  NSInteger * like;
  NSInteger * comment;
  
}
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *imageNail;
@property (nonatomic, retain) NSString *imageLarge;
@property (nonatomic, retain) NSString *videoNail;
@property (nonatomic, retain) NSString *videoLarge;
@property (nonatomic, retain) NSString *userProfile;
@property (nonatomic, retain) NSString *name;
@property (nonatomic) NSInteger like;
@property (nonatomic) NSInteger comment;

@end

