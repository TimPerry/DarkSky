//
//  AppDelegate.h
//  DarkSky
//
//  Created by TIM PERRY on 13/09/2011.
//  Copyright TPN.Net 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
