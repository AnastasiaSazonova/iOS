//
//  THDiaryEntryViewController.m
//  Diary
//
//  Created by Anastasia on 7/14/14.
//  Copyright (c) 2014 Anastasia Sazonova. All rights reserved.
//

#import "THEntryListViewController.h"
#import "CoreDataStack.h"
#import "THDiaryEntity.h"
#import "THEntryViewController.h"
#import "THEntryCell.h"

@interface THEntryListViewController ()<NSFetchedResultsControllerDelegate>

@property(nonatomic, strong)NSFetchedResultsController * fetchResultsController;

@end

@implementation THEntryListViewController

-(NSFetchedResultsController *)fetchResultsController
{
    if (_fetchResultsController != nil)
    {
        return _fetchResultsController;
    }
    CoreDataStack * coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest * fetchRequest = [self entryListFetchRequest];
    _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    _fetchResultsController.delegate = self;
    return _fetchResultsController;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchResultsController sections][section];
    return [sectionInfo name];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (IBAction)edit:(UIBarButtonItem *)sender
{
    BOOL edited = ![self.tableView isEditing];
    [self.tableView setEditing:edited animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /* Executes the fetch request on the store to get objects.
     Returns YES if successful or NO (and an error) if a problem occurred.
     An error is returned if the fetch request specified doesn't include a sort descriptor that uses sectionNameKeyPath.
     After executing this method, the fetched objects can be accessed with the property 'fetchedObjects'
     */
    [self.fetchResultsController performFetch:nil];
}

-(NSFetchRequest *)entryListFetchRequest
{
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"THDiaryEntity"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    return fetchRequest;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.fetchResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    THDiaryEntity * diaryEntry = [self.fetchResultsController objectAtIndexPath:indexPath];
    [cell configureCellForEntry:diaryEntry];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    THDiaryEntity * entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    CoreDataStack * stack = [CoreDataStack defaultStack];
    [stack.managedObjectContext deleteObject:entry];
    [stack saveContext];
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            break;
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"edit"])
    {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        THEntryViewController * entryViewController = (THEntryViewController *)navigationController.topViewController;
        entryViewController.entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    }
}

// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THDiaryEntity * entry = [self.fetchResultsController objectAtIndexPath:indexPath];
    return [THEntryCell heightForEntry:entry];
}

// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

@end
