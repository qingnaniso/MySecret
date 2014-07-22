//
//  SecretPhotosLibViewController.m
//  私人相册
//
//  Created by Qiqingnan on 14-7-1.
//  Copyright (c) 2014年 qingnan qi. All rights reserved.
//

#import "SecretPhotosLibViewController.h"
#import "ASTextField/ASTextField.h"

#define PRIVATE_PASSWORD_DOCUMENT @"privateAlbum201407190042"
@interface SecretPhotosLibViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) BOOL showFirstPage;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (strong, nonatomic) NSString *id;
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
@property (strong, nonatomic) NSString *filePath;
@property (strong, nonatomic) NSString *pswd;
@property (nonatomic) CGRect labelFrame;
@property (nonatomic) CGRect passwordFrame;
@property (nonatomic) CGRect OKButtonFrame;



@end

@implementation SecretPhotosLibViewController
- (IBAction)OK:(id)sender {
    
}
- (IBAction)touchDown:(id)sender {
    [self.password resignFirstResponder];
    [self.password2 resignFirstResponder];
}
-(void)shouldShowFirstPage
{
    if (!self.showFirstPage) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:PRIVATE_PASSWORD_DOCUMENT];
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
            self.pswd = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
            self.showFirstPage  = NO;
        } else{
            self.showFirstPage  = YES;
        }
    }
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self shouldShowFirstPage];
    self.password.delegate = self;
    self.password.secureTextEntry = YES;
    self.password2.delegate = self;
    self.password2.secureTextEntry = YES;
    self.OKButton.enabled = NO;
}

#define INPUT_PASSWORD @"请输入密码"
#define FIRST_INPUT @"首次登陆请设定密码："
#define BACK_LOGIN @"返回登陆"
-(void)viewWillAppear:(BOOL)animated
{

    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        self.pswd = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
        self.showFirstPage  = NO;
    } else{
        self.showFirstPage  = YES;
    }
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (self.showFirstPage == YES) {
        [self.password setupTextFieldWithIconName:@"password_icon"];
        CGRect password2Rect = self.password.frame;
        password2Rect = CGRectMake(password2Rect.origin.x, password2Rect.origin.y - password2Rect.size.height - 14, password2Rect.size.width, password2Rect.size.height);
        [self.password2 setupTextFieldWithIconName:@"password_icon"];
        [self.password2 setFrame:password2Rect];
        self.label.text = FIRST_INPUT;
        [self.label setFrame:CGRectMake(password2Rect.origin.x, password2Rect.origin.y - self.label.frame.size.height - 14, self.label.frame.size.width, self.label.frame.size.height)];
        [self.password setPlaceholder:@"再次输入密码"];
        [self.password2 setPlaceholder:@"请您输入密码"];
    } else {
        self.label.frame = CGRectMake(35, 161, 218, 21);
        self.password.frame = CGRectMake(35, 199, 250, 35);
        self.OKButton.frame = CGRectMake(35, 248, 250, 35);
        self.password.text = nil;
        self.OKButton.enabled = NO;
        [self.password setupTextFieldWithIconName:@"password_icon"];
        if (self.password2) {
            [self.password2 removeFromSuperview];
        }
        self.label.text = INPUT_PASSWORD;
        [self.password setPlaceholder:INPUT_PASSWORD];
    }
    [self.OKButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = BACK_LOGIN;
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma -mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.showFirstPage) {
        self.label.text = FIRST_INPUT;
        self.label.textColor = [UIColor blackColor];
    }
    return YES;
}

#define PSW_CANT_BLANK @"密码不能为空"
#define PSW_NOT_SAME @"两次输入密码不一致"
#define PSW_SET_SUCCESS @"设定密码成功！"
#define PSW_INPUT_RIGHT @"密码正确！"
#define PSW_INPUT_WRONG @"密码错误请重新输入："
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.showFirstPage) {
        [self.password resignFirstResponder];
        [self.password2 resignFirstResponder];
        if ([self.password.text isEqualToString:@""] || [self.password2.text isEqualToString:@""]) {
            self.label.text = PSW_CANT_BLANK;
            self.label.textColor = [UIColor redColor];
            return YES;
        }
        if (![self.password.text isEqualToString:self.password2.text]) {
            self.label.text = PSW_NOT_SAME;
            self.label.textColor = [UIColor redColor];
            return YES;
        }
        dispatch_queue_t writeToDocument = dispatch_queue_create("writeQ", NULL);
        dispatch_async(writeToDocument, ^{
            NSError *error;
            [self.password.text writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.label.text = PSW_SET_SUCCESS;
                [self showSuccessFade];
            });
        });
        return YES;
    } else {
        [self.password resignFirstResponder];
        if ([self.password.text isEqualToString:self.pswd]) {
            self.label.textColor = [UIColor blackColor];
            self.label.text = PSW_INPUT_RIGHT;
            self.OKButton.enabled = YES;
            [self.OKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.password.text = nil;
        } else {
            self.label.text = PSW_INPUT_WRONG;
            self.label.textColor = [UIColor redColor];
            return YES;
        }
    }
    return YES;
}

-(void)showSuccessFade
{
    [UIView animateWithDuration:1 animations:^{
        CGRect buttonMoveTo = self.password2.frame;
        [self.password setFrame:CGRectMake(-self.password.frame.origin.x-300, self.password.frame.origin.y, self.password.frame.size.width, self.password.frame.size.height)];
        [self.password2 setFrame:CGRectMake(self.password2.frame.origin.x + 300, self.password2.frame.origin.y, self.password2.frame.size.width, self.password2.frame.size.height)];
        [self.OKButton setFrame:CGRectMake(buttonMoveTo.origin.x, buttonMoveTo.origin.y, self.OKButton.frame.size.width, self.OKButton.frame.size.height)];
        self.OKButton.enabled = YES;
    } completion:^(BOOL finished) {
        [self.OKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]] && [segue.identifier isEqualToString:self.id]) {
        
    }
}
@end
