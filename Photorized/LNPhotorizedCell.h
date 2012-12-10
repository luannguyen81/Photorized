
#import <UIKit/UIKit.h>

@class LNPhoto;

@interface LNPhotorizedCell : UICollectionViewCell
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) LNPhoto *photo;
@end
