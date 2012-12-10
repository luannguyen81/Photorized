
#import "LNPhotorizedHeaderView.h"

@interface LNPhotorizedHeaderView ()
@property(weak) IBOutlet UIImageView *backgroundImageView;
@property(weak) IBOutlet UILabel *searchLabel;
@end

@implementation LNPhotorizedHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.searchLabel.text = @"farts";
    }
    return self;
}

- (void) setSearchText:(NSString *)text
{
    self.searchLabel.text = text;
    
    UIImage *shareButtonImage = [[UIImage
                                  imageNamed:@"header_bg.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(68, 68, 68, 68)];
    
    self.backgroundImageView.image = shareButtonImage;
    self.backgroundImageView.center = self.center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
