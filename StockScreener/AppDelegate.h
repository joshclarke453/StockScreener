//
//  AppDelegate.h
//  StockScreener
//
//  Created by Mark Windsor on 11/8/18.
//  Copyright © 2018 FLO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

