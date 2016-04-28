//
//  NSObject+InfoObject.m
//  SmallProject
//
//  Created by FangXin on 4/28/16.
//  Copyright © 2016 FangXin. All rights reserved.
//

#import "InfoObject.h"

@implementation InfoObject
@synthesize id;
@synthesize type;
@synthesize imageNail;
@synthesize imageLarge;
@synthesize videoNail;
@synthesize videoLarge;
@synthesize userProfile;
@synthesize name;


- (id)init
{
  if (self = [super init])
  {
    self.id = @"";
    self.type = @"";
    self.imageNail = @"";
    self.imageLarge = @"";
    self.videoNail = @"";
    self.videoLarge = @"";
    self.userProfile = @"";
    self.name = @"";
    self.like = 0;
    self.comment = 0;
  }
  return self;
}
@end
