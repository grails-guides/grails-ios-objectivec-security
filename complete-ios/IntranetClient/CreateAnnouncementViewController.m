#import "CreateAnnouncementViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AnnouncementUseCase.h"

@interface CreateAnnouncementViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tilteTextField;
@property (weak, nonatomic) IBOutlet UITextField *bodyTextField;

@property ( nonatomic, strong ) AnnouncementUseCase *useCase;

@end

@implementation CreateAnnouncementViewController

#pragma mark - IBAction

- (IBAction)saveTapped:(id)sender {
    NSString *title = self.tilteTextField.text;
    NSString *message = self.bodyTextField.text;
    
    [self.useCase saveAnnouncementWithTitle:title body:message completionHandler:^(Announcement *announcement, NSError *error) {
        if ( error ) {
            
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Lazy

- (AnnouncementUseCase *)useCase {
    if(!_useCase) {
        _useCase = [[AnnouncementUseCase alloc] init];
    }
    return _useCase;
}

@end
