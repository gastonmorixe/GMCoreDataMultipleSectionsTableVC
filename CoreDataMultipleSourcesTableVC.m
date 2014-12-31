//
//  CoreDataMultipleSourcesTableVC.m
//
//  Created by Gaston Morixe on 12/30/14.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Gaston Morixe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "CoreDataMultipleSourcesTableVC.h"

@implementation CoreDataMultipleSourcesTableVC

#pragma mark - Fetching

- (NSUInteger) sectionForFetchedResultController:(NSFetchedResultsController*)fetchedResultController {
    return [self.fetchedResultsControllers indexOfObject:fetchedResultController];
}

- (void)performFetch:(NSFetchedResultsController*)fetchedResultsController
{
    if (fetchedResultsController) {
        NSError *error;
        BOOL success = [fetchedResultsController performFetch:&error];
        if (!success){
            NSLog(@"[%@ %@] performFetch: failed", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        }
        if (error){
            NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[self sectionForFetchedResultController:fetchedResultsController]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)setFetchedResultsControllers:(NSArray *)fetchedResultsControllers{
    _fetchedResultsControllers = fetchedResultsControllers;
    [fetchedResultsControllers enumerateObjectsUsingBlock:^(NSFetchedResultsController* fetchedResultsController, NSUInteger idx, BOOL *stop) {
        fetchedResultsController.delegate = self;
        [self performFetch:fetchedResultsController];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsControllers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSFetchedResultsController* fetchedResultsController = [self.fetchedResultsControllers objectAtIndex:section];
    NSInteger rows = 0;
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    int sectionIndexComputed = (int)[self sectionForFetchedResultController:controller];
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndexComputed]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndexComputed]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        default:
            NSLog(@"Wow, this is not suppoused to be happnening.");
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if ((indexPath && indexPath.section > 0) || (newIndexPath && newIndexPath.section > 0)) {
        return;
    }
    
    int sectionIndexComputed = (int)[self sectionForFetchedResultController:controller];
    NSArray* indexPathComputed = @[[NSIndexPath indexPathForRow:indexPath.row inSection:sectionIndexComputed]];
    NSArray* newIndexPathComputed = (newIndexPath)? @[[NSIndexPath indexPathForRow:newIndexPath.row inSection:sectionIndexComputed]] : nil;
    NSLog(@" section %i path %i | section %i path %i  ", indexPath.section, indexPath.row, ((NSIndexPath*)indexPathComputed[0]).section, ((NSIndexPath*)indexPathComputed[0]).row );
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:newIndexPathComputed
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:indexPathComputed
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:indexPathComputed
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:indexPathComputed
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:newIndexPathComputed
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
