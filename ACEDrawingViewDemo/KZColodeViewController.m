#import "KZColodeViewController.h"
#import "KZColodeDrawingView.h"
#import <QuartzCore/QuartzCore.h>

#define kActionSheetColor       100
#define kActionSheetTool        101
#define kActionSheetColode      102

@interface KZColodeViewController ()<UIActionSheetDelegate, KZColodeDrawingViewDelegate>

@end

@implementation KZColodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Set the delegate
    self.drawingView.delegate = self;
    
    //Reset the device data
    self.colodeDeviceData = nil;
    
    //Black pen is the default start
    self.lineWidthSlider.value = self.drawingView.lineWidth;
    
    //Start the central manager. Start up the BLE processes for the hardware using this application e.g. phone or ipad
    CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.centralManager = centralManager;
}

- (void)didReceiveMemoryWarning
{
    //Dispose of any recourses that can be recreated
    [super didReceiveMemoryWarning];
}


#pragma mark - Actions

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.drawingView canUndo];
    self.redoButton.enabled = [self.drawingView canRedo];
}

- (IBAction)undo:(id)sender
{
    [self.drawingView undoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)redo:(id)sender
{
    [self.drawingView redoLatestStep];
    [self updateButtonStatus];
}

- (IBAction)clear:(id)sender
{
    [self.drawingView clear];
    [self updateButtonStatus];
}


#pragma mark - KZColodeDrawing View Delegate

- (void)drawingView:(KZColodeDrawingView *)view didEndDrawUsingTool:(id<KZColodeDrawingTool>)tool;
{
    [self updateButtonStatus];
}


#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        if (actionSheet.tag == kActionSheetColor) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor blackColor];
                    self.colorButton.tintColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor redColor];
                    self.colorButton.tintColor = [UIColor redColor];

                    break;
                    
                case 2:
                    self.drawingView.lineColor = [UIColor greenColor];
                    self.colorButton.tintColor = [UIColor greenColor];
                    break;
                    
                case 3:
                    self.drawingView.lineColor = [UIColor blueColor];
                    self.colorButton.tintColor = [UIColor blueColor];
                    break;
                    
                case 4:
                    self.drawingView.lineColor = [UIColor brownColor];
                    self.colorButton.tintColor = [UIColor brownColor];
                    break;
                    
                case 5:
                    self.drawingView.lineColor = [UIColor orangeColor];
                    self.colorButton.tintColor = [UIColor orangeColor];
                    break;
                    
                case 6:
                    self.drawingView.lineColor = [UIColor purpleColor];
                    self.colorButton.tintColor = [UIColor purpleColor];
                    break;
                    
                case 7:
                    self.drawingView.lineColor = [UIColor yellowColor];
                    self.colorButton.tintColor = [UIColor yellowColor];
                    break;
                    
            }
            
        } else if (actionSheet.tag == kActionSheetTool) {
            
            self.toolButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.drawTool = KZColodeDrawingToolTypePen;
                    break;
                    
                case 1:
                    self.drawingView.drawTool = KZColodeDrawingToolTypeLine;
                    break;
                    
                case 2:
                    self.drawingView.drawTool = KZColodeDrawingToolTypeRectagleStroke;
                    break;
                    
                case 3:
                    self.drawingView.drawTool = KZColodeDrawingToolTypeRectagleFill;
                    break;
                    
                case 4:
                    self.drawingView.drawTool = KZColodeDrawingToolTypeEllipseStroke;
                    break;
                    
                case 5:
                    self.drawingView.drawTool = KZColodeDrawingToolTypeEllipseFill;
                    break;
                    
                case 6:
                    self.drawingView.drawTool = KZColodeDrawingToolTypeEraser;
                    break;
                    
                case 7:
                    self.drawingView.drawTool = KZColodeDrawingToolTypeText;
                    break;
            }
            // if eraser, disable color and alpha selection
            self.colorButton.enabled = self.alphaButton.enabled = buttonIndex != 6;

        } else if (actionSheet.tag == kActionSheetColode) {
            
            self.colorButton.title = [actionSheet buttonTitleAtIndex:buttonIndex];
            switch (buttonIndex) {
                case 0:
                    self.drawingView.lineColor = [UIColor blackColor];
                    break;
                    
                case 1:
                    self.drawingView.lineColor = [UIColor redColor];
                    break;
            }
            
            
        }
    }
}

#pragma mark - Settings

- (IBAction)colorChange:(id)sender
{
    //Assign the color text to the buttons
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a color"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Black", @"Red", @"Green", @"Blue", @"Brown", @"Orange", @"Purple", @"Yellow", nil];
    
    [actionSheet setTag:kActionSheetColor];
    [actionSheet showInView:self.view];
    
}

- (IBAction)colodeChange:(id)sender
{
    //Assign the color of the stored colode color to the pen
    self.drawingView.lineColor = [self colorWithHexString:self.storedColor];
    self.colorButton.tintColor = [self colorWithHexString:self.storedColor];
}


- (IBAction)toolChange:(id)sender
{
    //Assign the tool text to the buttons
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a tool"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Pen", @"Line",
                                  @"Rect (Stroke)", @"Rect (Fill)",
                                  @"Ellipse (Stroke)", @"Ellipse (Fill)",
                                  @"Eraser", @"Text",
                                  nil];
    
    [actionSheet setTag:kActionSheetTool];
    [actionSheet showInView:self.view];
}

- (IBAction)toggleWidthSlider:(id)sender
{
    // toggle the slider
    self.lineWidthSlider.hidden = !self.lineWidthSlider.hidden;
    if (self.lineWidthSlider.hidden == NO)
    {
        self.widthButton.tintColor = [UIColor redColor];
        self.alphaButton.tintColor = [UIColor blueColor];
    } else {
        self.widthButton.tintColor = [UIColor blueColor];
    }
    self.lineAlphaSlider.hidden = YES;
    }


- (IBAction)widthChange:(UISlider *)sender
{
    self.drawingView.lineWidth = sender.value;
}

- (IBAction)toggleAlphaSlider:(id)sender
{
    // toggle the slider
    self.lineAlphaSlider.hidden = !self.lineAlphaSlider.hidden;
    if (self.lineAlphaSlider.hidden == NO)
    {
        self.alphaButton.tintColor = [UIColor redColor];
        self.widthButton.tintColor = [UIColor blueColor];
    } else {
        self.alphaButton.tintColor = [UIColor blueColor];
    }
    self.lineWidthSlider.hidden = YES;
    
}

- (IBAction)alphaChange:(UISlider *)sender
{
    self.drawingView.lineAlpha = sender.value;
}

#pragma mark -  BLE Connection

//Check the status of the central manager. This is needed for the device that this application runs on
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        //Scan for peripherals after the central manager is powered on and ready.
        NSArray *services = @[[CBUUID UUIDWithString:COLODE_DATA_SERVICE_UUID], [CBUUID UUIDWithString:COLODE_DEVICE_INFO_SERVICE_UUID]];
        [self.centralManager scanForPeripheralsWithServices:services options:nil];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

// This contains most of the information about the discovered peripheral
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if (![localName isEqual:@""]) {
        //We found our peripheral
        [self.centralManager stopScan];
        self.colodePeripheral = peripheral;
        peripheral.delegate = self;
        //Connect to the peripheral
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

//Method called whenever we have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    //Discover the available services for our peripheral
    [peripheral discoverServices:nil];
}


#pragma mark - BLE Peripheral explore

//Method called whenever services are found of the peripheral
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        //Disocver the available characteristics for our peripheral
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//Method called whenever characteristics are found for the service
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    //Check if the service found is the colode data service
    if ([service.UUID isEqual:[CBUUID UUIDWithString:COLODE_DATA_SERVICE_UUID]])  {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            //Request colode color notifications
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:COLODE_COLOR_CHARACTERISTIC_UUID]]) {
                [self.colodePeripheral setNotifyValue:YES forCharacteristic:aChar];
            }
            
        }
    }
    //Check if the service found is the colode device information service
    if ([service.UUID isEqual:[CBUUID UUIDWithString:COLODE_DEVICE_INFO_SERVICE_UUID]])  {
        for (CBCharacteristic *aChar in service.characteristics)
        {
            //Request the colode manufacturer name
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:COLODE_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {
                [self.colodePeripheral readValueForCharacteristic:aChar];
            }
        }
    }
}

//Method called when a characteristic that we requested to be notified of changes
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //Check if the characteristic is the color
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:COLODE_COLOR_CHARACTERISTIC_UUID]]) {
        //Update the color value
        [self getColorData:characteristic error:error];
    }
    //Check if the characteristic if the manufacturer
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:COLODE_MANUFACTURER_NAME_CHARACTERISTIC_UUID]]) {  //Get the manufacturer name
        [self getManufacturerName:characteristic];
    }
}

#pragma mark - Methods

//Instance method to get the color
- (void) getColorData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //Set the storedColor variable to the retrieved value from the peripheral
    self.storedColor = [[NSString alloc] initWithData:characteristic.value encoding:NSASCIIStringEncoding];
}

//Instance method to get the manufacturer name of the device
- (void) getManufacturerName:(CBCharacteristic *)characteristic
{
    NSString *manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
}

//Method to convert a string in the format of hex (e.g. FF0000) to UIColor RGB values
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    //Strip 0X if it appears
    if ([cString hasPrefix:@"0x"]) cString = [cString substringFromIndex:2];
    
    //Set color to gray if the data received is not a valid color
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end

