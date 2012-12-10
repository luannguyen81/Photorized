
#import <Foundation/Foundation.h>

typedef enum {
  LNPhotoSourceTypeFlickr = 0,
  LNPhotoSourceTypeLocal,
  LNPhotoSourceTypeFacebook
} LNPhotoSourceType;

@interface LNPhoto : NSObject
@property(nonatomic,strong) UIImage *thumbnail;
@property(nonatomic,strong) UIImage *largeImage;

// Lookup info
@property(nonatomic) long long photoID;
@property(nonatomic) NSInteger farm;
@property(nonatomic) NSInteger server;
@property(nonatomic,strong) NSString *secret;
@property(nonatomic) LNPhotoSourceType sourceType;

@end
