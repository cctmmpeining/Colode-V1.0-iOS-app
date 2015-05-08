//
//  KZColodeViewController.h
//  KZColodeDrawingViewDemo
//
//  Created by Stefano KZColoderbetti on 1/6/13.
//  Copyright (c) 2013 Stefano KZColoderbetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <QuartzCore/QuartzCore.h>

@class KZColodeDrawingView;

//
//#define COLODE_DEVICE_INFO_SERVICE_UUID @"180A"       // 180A = Device Information
//#define COLODE_DATA_SERVICE_UUID @"84A7B6AB-6B3E-4FC7-8C71-C3A481A26159" // Device UUID
//#define COLODE_COLOR_CHARACTERISTIC_UUID @"9A4C3147-2A24-43F7-8B78-754AE1B7457B" // Color characteristic UUID


#define COLODE_DEVICE_INFO_SERVICE_UUID @"180A"       // 180A = Device Information
#define COLODE_DATA_SERVICE_UUID @"7B61A721-3E7A-4235-9FD7-E1AB49D070CA" // Device UUID
#define COLODE_COLOR_CHARACTERISTIC_UUID @"7DB47BC5-0C03-4C91-A2C9-B8E841F7253F" // Color characteristic UUID

#define COLODE_MANUFACTURER_NAME_CHARACTERISTIC_UUID @"2A29" // 2A29 = Manufacturer Name


@interface KZColodeViewController : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) CBPeripheral     *colodePeripheral;

@property (nonatomic, strong) NSString   *connected;
@property (nonatomic, strong) NSString   *manufacturer;
@property (nonatomic, strong) NSString   *colodeDeviceData;
@property (nonatomic, strong) NSString   *storedColor;

@property (nonatomic, unsafe_unretained) IBOutlet KZColodeDrawingView *drawingView;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineWidthSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UISlider *lineAlphaSlider;
@property (nonatomic, unsafe_unretained) IBOutlet UIImageView *previewImageView;

@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *undoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *redoButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *colorButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *toolButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *alphaButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *widthButton;
@property (nonatomic, unsafe_unretained) IBOutlet UIBarButtonItem *colodeButton;

// actions
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)clear:(id)sender;

// settings
- (IBAction)colorChange:(id)sender;
- (IBAction)toolChange:(id)sender;
- (IBAction)toggleWidthSlider:(id)sender;
- (IBAction)widthChange:(UISlider *)sender;
- (IBAction)toggleAlphaSlider:(id)sender;
- (IBAction)alphaChange:(UISlider *)sender;
- (IBAction)colodeChange:(id)sender;

- (UIColor*)colorWithHexString:(NSString *)hex;

@end
