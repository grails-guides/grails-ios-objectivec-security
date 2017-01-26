#import "LoginViewController.h"
#import <GrailsSpringSecurityRestObjc/GrailsApi.h>
#import "GrailsFetcher.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (strong, nonatomic) GrailsApi *grailsApi;

@end

@implementation LoginViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

#pragma mark - IBAction

- (IBAction)loginButtonTapped:(id)sender {
    
    self.loginButton.enabled = NO;
    [self.activityIndicatorView startAnimating];
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [self.grailsApi loginGrailsServerUrl:kServerUrl username:username password:password withCompletionHandler:^(NSError *error) {
        if ( error ) {
            [self configureView];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }];
}

#pragma mark - Private Methods

- (void)configureView {
    self.loginButton.enabled = YES;
    [self.activityIndicatorView stopAnimating];
    
}

#pragma mark - Lazy

- (GrailsApi *)grailsApi {
    if ( _grailsApi == nil ) {
        _grailsApi = [[GrailsApi alloc] init];
    }
    return _grailsApi;
}

@end
