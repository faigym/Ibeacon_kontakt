//
//  ViewController.h
//  kontak2
//
//  Created by Jens Andersen on 23/07/14.
//  Copyright (c) 2014 com.appcoda. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface ViewController : UIViewController <KTKLocationManagerDelegate,KTKActionManagerDelegate, KTKBluetoothManagerDelegate>{

    
}

@property (strong, nonatomic) KTKLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) KTKClient *client;

@property   (strong,nonatomic)  NSString *info;

@property (strong, nonatomic) KTKBeaconManager *beaconManager;
@property (strong, nonatomic) KTKActionManager *actionManager;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;




@end
