//
//  PlayerDetails+CoreDataProperties.h
//  
//
//  Created by Kara Vaillancourt on 5/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlayerDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) Player *relationship;

@end

NS_ASSUME_NONNULL_END
