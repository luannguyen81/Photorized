
#import <Foundation/Foundation.h>

@class LNPhoto;

typedef void (^FlickrSearchCompletionBlock)(NSString *searchTerm, NSArray *results, NSError *error);
typedef void (^FlickrPhotoCompletionBlock)(UIImage *photoImage, NSError *error);

@interface LNPhotoSource : NSObject

@property(strong) NSString *apiKey;

- (void)searchFlickrForTerm:(NSString *) term completionBlock:(FlickrSearchCompletionBlock) completionBlock;
+ (void)loadImageForPhoto:(LNPhoto *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock) completionBlock;
+ (NSString *)flickrPhotoURLForFlickrPhoto:(LNPhoto *) flickrPhoto size:(NSString *) size;

@end
