//
//  Player+CoreDataProperties.h
//  
//
//  Created by Kara Vaillancourt on 5/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Player.h"

NS_ASSUME_NONNULL_BEGIN

@interface Player (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *relationship;

@end

NS_ASSUME_NONNULL_END
