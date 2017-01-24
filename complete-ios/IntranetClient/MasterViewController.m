#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AnnouncementUseCase.h"
#import "AnnouncementsTableViewDataSource.h"
#import "AnnouncementsTableViewDelegate.h"
#import "Announcement.h"
#import "GrailsApi.h"
#import "LoginViewController.h"

static NSString *kSegueShowDetail = @"showDetail";
static NSString *kSegueShowCreateForm = @"showCreateForm";

@interface MasterViewController ()

@property NSMutableArray *objects;

@property ( nonatomic, strong ) AnnouncementUseCase *useCase;

@property ( nonatomic, strong) id<UITableViewDataSource> tableViewDataSource;

@property ( nonatomic, strong) id<UITableViewDelegate> tableViewDelegate;

@property (nonatomic, strong) GrailsApi *grailsApi;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewDataSource = [[AnnouncementsTableViewDataSource alloc] init];
    self.tableViewDelegate = [[AnnouncementsTableViewDelegate alloc] init];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.delegate = self.tableViewDelegate;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    [self configureNavigationItem];
    [self registerNotifications];
    [self fetchAnnouncements];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

#pragma mark - Notifications

-(void)registerNotifications {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(announcementTapped:) name:kAnnouncementTappedNotification object:nil];
}

- (void)unregisterNotifications {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:kAnnouncementTappedNotification object:nil];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kSegueShowDetail]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        if([sender isKindOfClass:[Announcement class]]) {
            Announcement *announcement = (Announcement *)sender;
            controller.announcementPrimaryKey = announcement.primaryKey; // <1>
        }
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)segueSignInViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:kStoryBoardSignIn bundle:nil];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:kViewControllerSignIn];
    [self presentViewController:viewController animated:true completion:^{}];
}

#pragma mark - Private Methods

- (void)configureRightBarButton {
    if ( [self.grailsApi hasRole:@"ROLE_BOSS"] ) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTapped:)];
        self.navigationItem.rightBarButtonItem = addButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)configureLeftBarButton {
    NSString *username = [self.grailsApi loggedUsername];
    if ( username ) {
        
        NSString *logoutTitle = NSLocalizedString(@"Logout", @"Logout bar button item");
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:logoutTitle
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(logoutTapped:)];
        self.navigationItem.leftBarButtonItem = logoutButton;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)configureNavigationTitle {
    NSString *username = [self.grailsApi loggedUsername];
    self.navigationItem.title = username;
    
}

- (void)configureNavigationItem {
    [self configureNavigationTitle];
    [self configureLeftBarButton];
    [self configureRightBarButton];
}

- (void)logoutTapped:(id)sender {
    [self.grailsApi logout];
    [self segueSignInViewController];
}

- (void)addTapped:(id)sender {
    [self performSegueWithIdentifier:kSegueShowCreateForm sender:nil];
}

- (void)announcementTapped:(NSNotification *)notification {
    if([[notification object] isKindOfClass:[Announcement class]]) {
        Announcement *announcement = (Announcement *)[notification object];
        [self performSegueWithIdentifier:kSegueShowDetail sender:announcement];
    }
}

- (void)setNetworkActivityIndicator:(BOOL)visible {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:visible];
}

- (void)fetchAnnouncements {
    [self setNetworkActivityIndicator:YES];
    [self.useCase findAllAnnouncementsWithCompletionHandler:^(NSArray *announcements, NSError *error) {
        
        [self setNetworkActivityIndicator:NO];

        if ( announcements != nil ) {
            if ( [self.tableViewDataSource isKindOfClass:[AnnouncementsTableViewDataSource class]]) {
                ((AnnouncementsTableViewDataSource *)self.tableViewDataSource).announcements = announcements;
            }
            if ( [self.tableViewDelegate isKindOfClass:[AnnouncementsTableViewDelegate class]]) {
                ((AnnouncementsTableViewDelegate *)self.tableViewDelegate).announcements = announcements;
            }
            [self.tableView reloadData];
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
                                 
- (GrailsApi *)grailsApi {
    if(!_grailsApi) {
        _grailsApi = [[GrailsApi alloc] init];
    }
    return _grailsApi;
}
                                 
                                 
@end
