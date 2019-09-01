#import "MainTableViewController.h"
#import "NotesViewController.h"

@interface MainTableViewController ()

@property (nonatomic, strong) NSMutableArray * arrayEvents;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.arrayEvents = [[NSMutableArray alloc] initWithArray:array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewWhenNewEvent) name:@"NewEvent"  object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) reloadTableViewWhenNewEvent {
    
    [self.arrayEvents removeAllObjects];
    NSArray * array = [[UIApplication sharedApplication] scheduledLocalNotifications];
    self.arrayEvents = [[NSMutableArray alloc] initWithArray:array];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    UILocalNotification * notification = [self.arrayEvents objectAtIndex:indexPath.row];
    NSDictionary * dict = notification.userInfo;
    cell.textLabel.text = [dict objectForKey:@"eventInfo"];
    cell.detailTextLabel.text = [dict objectForKey:@"eventDate"];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UILocalNotification * notification = [self.arrayEvents objectAtIndex:indexPath.row];
    NSDictionary * dict = notification.userInfo;
    NotesViewController * notesView = [self.storyboard instantiateViewControllerWithIdentifier:@"notesView"];
    notesView.eventInfo = [dict objectForKey:@"eventInfo"];
    notesView.eventDate = notification.fireDate;
    notesView.isDetail = YES;
    [self.navigationController pushViewController:notesView animated:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UILocalNotification * notification = [self.arrayEvents objectAtIndex:indexPath.row];
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        [self.arrayEvents removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

@end
