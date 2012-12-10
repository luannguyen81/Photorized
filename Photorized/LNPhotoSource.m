
#import "LNPhotoSource.h"
#import "LNPhoto.h"

#define kFlickrAPIKey @"d02c877c0a4220890f14fc95f8b16983"

@implementation LNPhotoSource

+ (NSString *)flickrSearchURLForSearchTerm:(NSString *) searchTerm
{
    searchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&per_page=20&format=json&nojsoncallback=1",kFlickrAPIKey,searchTerm];
}

+ (NSString *)flickrPhotoURLForFlickrPhoto:(LNPhoto *) flickrPhoto size:(NSString *) size
{
    if(!size)
    {
        size = @"m";
    }
    return [NSString stringWithFormat:@"http://farm%d.staticflickr.com/%d/%lld_%@_%@.jpg",flickrPhoto.farm,flickrPhoto.server,flickrPhoto.photoID,flickrPhoto.secret,size];
}

- (NSArray*)getImageFromSourcePhotos:(NSArray*)objPhotos photoSourceType:(LNPhotoSourceType)sourceType
{
  NSError *error = nil;
  NSData *imageData = nil;
  NSMutableArray *images = [@[] mutableCopy];
  
  for(NSMutableDictionary *objPhoto in objPhotos)
  {
    LNPhoto *photo = [[LNPhoto alloc] init];
    photo.farm = [objPhoto[@"farm"] intValue];
    photo.server = [objPhoto[@"server"] intValue];
    photo.secret = objPhoto[@"secret"];
    photo.photoID = [objPhoto[@"id"] longLongValue];
    photo.sourceType = LNPhotoSourceTypeFlickr;
    
    switch (sourceType) {
      case LNPhotoSourceTypeFlickr:{
        NSString *searchURL = [LNPhotoSource flickrPhotoURLForFlickrPhoto:photo size:@"m"];
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        break;
      }
      default:
        break;
    }
    
    
    UIImage *image = [UIImage imageWithData:imageData];
    photo.thumbnail = image;
    
    [images addObject:photo];
  }
  return images;
}
- (void)searchFlickrForTerm:(NSString *) term completionBlock:(FlickrSearchCompletionBlock) completionBlock
{
  if ([term isEqualToString:@"local"]){
    
  }else{
    
    NSString *searchURL = [LNPhotoSource flickrSearchURLForSearchTerm:term];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSString *searchResultString = [NSString stringWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                           encoding:NSUTF8StringEncoding
                                                              error:&error];
        if (error != nil) {
            completionBlock(term,nil,error);
        }
        else
        {
            // Parse the JSON Response
            NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *searchResultsDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                              options:kNilOptions
                                                                                error:&error];
            if(error != nil)
            {
                completionBlock(term,nil,error);
            }
            else
            {
                NSString * status = searchResultsDict[@"stat"];
                if ([status isEqualToString:@"fail"]) {
                    NSError * error = [[NSError alloc] initWithDomain:@"FlickrSearch" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: searchResultsDict[@"message"]}];
                    completionBlock(term, nil, error);
                } else {
                
                  NSArray *objPhotos = searchResultsDict[@"photos"][@"photo"];
                  NSArray *flickrPhotos = [self getImageFromSourcePhotos:objPhotos photoSourceType:LNPhotoSourceTypeFlickr];
                  
                  completionBlock(term,flickrPhotos,nil);
                }
            }
        }
    });
  }
}

+ (void)loadImageForPhoto:(LNPhoto *)flickrPhoto thumbnail:(BOOL)thumbnail completionBlock:(FlickrPhotoCompletionBlock) completionBlock
{
  
    NSString *size = thumbnail ? @"m" : @"b";
  
    NSString *searchURL = [LNPhotoSource flickrPhotoURLForFlickrPhoto:flickrPhoto size:size];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  
    dispatch_async(queue, ^{
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        if(error)
        {
            completionBlock(nil,error);
        }
        else
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if([size isEqualToString:@"m"])
            {
                flickrPhoto.thumbnail = image;
            }
            else
            {
                flickrPhoto.largeImage = image;
            }
            completionBlock(image,nil);
        }
        
    });
}



@end
