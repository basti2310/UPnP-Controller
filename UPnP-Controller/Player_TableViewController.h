//
//  Player_TableViewController.h
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 26.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaRenderer1Device.h"

@interface Player_TableViewController : UITableViewController

@property (nonatomic, strong) NSArray *renderers;
@property (nonatomic, strong) MediaRenderer1Device *renderer;

@end
