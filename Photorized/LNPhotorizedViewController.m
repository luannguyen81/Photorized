
#import "LNPhotorizedViewController.h"
#import "LNPhotoSource.h"
#import "LNPhoto.h"

@interface LNPhotorizedViewController ()
@property(weak) IBOutlet UIImageView *imageView;
- (IBAction)done:(id) sender;
@end

@implementation LNPhotorizedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    if(self.photo.largeImage)
    {
        self.imageView.image = self.photo.largeImage;
    }
    else
    {
        self.imageView.image = self.photo.thumbnail;
        [LNPhotoSource loadImageForPhoto:self.photo thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
            
            if(!error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = self.photo.largeImage;
                });
            }
            
        }];
    }
}

- (void) done:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
