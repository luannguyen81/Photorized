
#import "LNPhotorizedCell.h"
#import "LNPhoto.h"
#import "LNPhotoSource.h"

@implementation LNPhotorizedCell

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        self.selectedBackgroundView = bgView;      
    }
    return self;
}

- (void) setPhoto:(LNPhoto *)photo
{
    if(_photo != photo)
    {
        _photo = photo;
    }
    
    self.imageView.image = _photo.thumbnail;
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
