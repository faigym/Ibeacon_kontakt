//
//  BeaconManager.h
//  Beacons
//
//  Created by logamic on 08/07/14.
//  Copyright (c) 2014 Logamic s.r.o. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTKBeaconManager.h"

@interface BeaconManager : KTKBeaconManager <KTKBluetoothManagerDelegate> 

@property (strong, nonatomic) BeaconManager *beaconManager;


@end
