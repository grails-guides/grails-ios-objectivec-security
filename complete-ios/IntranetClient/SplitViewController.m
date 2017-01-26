#import "SplitViewController.h"
#import <GrailsSpringSecurityRestObjc/GrailsApi.h>
#import "LoginViewController.h"

@interface SplitViewController ()

@property (nonatomic, strong)GrailsApi *grailsApi;

@end

@implementation SplitViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ( !([self.grailsApi hasRole:@"ROLE_EMPLOYEE"] || [self.grailsApi hasRole:@"ROLE_BOSS"]) ) {
        [self segueSignInViewController];
    }
}

#pragma mark - Segue

- (void)segueSignInViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kStoryBoardSignIn bundle:nil];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:kViewControllerSignIn];
    [self presentViewController:viewController animated:true completion:^{}];
}

#pragma mark - Lazy


- (GrailsApi *)grailsApi {
    if(!_grailsApi) {
        _grailsApi = [[GrailsApi alloc] init];
    }
    return _grailsApi;
}


@end
