#import <UIKit/UIKit.h>

@interface VideoTableViewCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIView *videoView;

@end
