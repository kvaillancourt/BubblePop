//
//  SettingsBundle+CoreDataProperties.h
//  
//
//  Created by Kara Vaillancourt on 5/8/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SettingsBundle.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingsBundle (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *movebubble;
@property (nullable, nonatomic, retain) NSNumber *maxtime;
@property (nullable, nonatomic, retain) NSNumber *maxbubbles;

@end

NS_ASSUME_NONNULL_END
