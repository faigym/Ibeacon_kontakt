//
//  BeaconManager.m
//  Beacons
//
//  Created by logamic on 08/07/14.
//  Copyright (c) 2014 Logamic s.r.o. All rights reserved.
//

#import "BeaconManager.h"
#import "KTKBeaconManager.h"
#import "KTKBeaconDevice.h"


@implementation BeaconManager
- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSLog(@"Delegate set to self.");
        self.delegate = self;
    }
    return self;
}

- (void)bluetoothManager:(KTKBluetoothManager *)bluetoothManager didChangeDevices:(NSSet *)devices {
    NSString *uuid = @"f7826da6-4fa2-4e98-8024-bc5b71e0893e";
    NSLog(@"Entered didChangeDevices. Devices size: %d", devices.count);
    
    for (KTKBeaconDevice *device in devices) {
        NSString *devuuid = device.uniqueID;
        if ([devuuid isEqualToString:uuid]) NSLog(@"%@ - In range.", devuuid);
        else NSLog(@"%@", devuuid);
    }
}





@end
