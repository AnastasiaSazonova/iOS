//
//  CoreDataStack.h
//  Diary
//
//  Created by Anastasia on 7/13/14.
//  Copyright (c) 2014 Anastasia Sazonova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataStack : NSObject

+(instancetype)defaultStack;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
