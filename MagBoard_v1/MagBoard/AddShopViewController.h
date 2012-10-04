//
//  AddShopViewController.h
//  MagBoard
//
//  Created by Dennis de Jong on 25-09-12.
//  Copyright (c) 2012 Dennis de Jong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddShopViewController : UIViewController

- (IBAction)resignKeyboard:(id)sender;
- (IBAction)saveWebshop:(id)sender;
- (IBAction)discardWebshop:(id)sender;
- (IBAction)textFieldReturn:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *nameWebshop;
@property (weak, nonatomic) IBOutlet UITextField *urlWebshop;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UISwitch *savePassword;
@property (weak, nonatomic) NSString *message;
@property (weak, nonatomic) NSString *alertTitle;
@property BOOL empty;

-(void)makeAlert:(NSString*)alertTitle message:(NSString*)alertMessage;

@end
