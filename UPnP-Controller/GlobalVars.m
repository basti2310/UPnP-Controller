//
//  GlobalVars.m
//  UPnP-Controller
//
//  Created by Sebastian Peischl on 27.04.14.
//  Copyright (c) 2014 easyMOBIZ. All rights reserved.
//

#import "GlobalVars.h"

@implementation GlobalVars

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.server = nil;
        self.renderer = nil;
        self.upnpDevices = nil;
        self.upnpServers = [[NSMutableArray alloc] init];
        self.upnpRenderer = [[NSMutableArray alloc] init];
        self.currentServerBasicObject = nil;
    }
    
    return self;
}

+ (GlobalVars *)sharedInstance
{
    static dispatch_once_t onceToken;
    static GlobalVars *instance = nil;
    
    dispatch_once(&onceToken, ^{
        instance = [[GlobalVars alloc] init];
    });
    
    return instance;
}

@end
