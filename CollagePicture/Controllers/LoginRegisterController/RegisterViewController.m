//
//  RegisterViewController.m
//  CollagePicture
//
//  Created by 朱新明 on 16/12/19.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "RegisterViewController.h"
#import "FullTextViewController.h"
#import "UserModel.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)NSTimer *smsDownTimer;
@property (nonatomic,assign)NSInteger smsDownSeconds;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView.frame = ZX_FRAME_H(self.tableHeaderView, LCDH_nav);
    
    self.userNameField.delegate = self;
    self.verificationCodeField.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#define PHONE_MAXLENGTH 11
#define VerfiCode_MAXLENGTH 6

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger maxLength = 0;
    if ([textField isEqual:self.userNameField]||[textField isEqual:self.verificationCodeField])
    {
       maxLength =[textField isEqual:self.userNameField]? PHONE_MAXLENGTH:VerfiCode_MAXLENGTH;
        if (range.location>= maxLength) //输入文字/删除文字后,但还没有改变textField时候的改变;
        {
            textField.text = [textField.text substringToIndex:maxLength];
            return NO;
        }


    }
       return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)touchDownAction:(UIControl *)sender {
    
    [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


#pragma mark - 请求验证码

- (IBAction)requestSmsCodeBtnAction:(UIButton *)sender {
    NSString *mobilePhoneNumber = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];

    if (![UITextField zhu_validatePhoneNumber:mobilePhoneNumber])
    {
        [self zhHUD_showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    //我暂时没有自定义模版，用系统短信
    WS(weakSelf);
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:mobilePhoneNumber andTemplate:nil resultBlock:^(int number, NSError *error) {
        
        if (error)
        {
            [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
        }
        else
        {
            NSLog(@"smsID:%d",number);
            [weakSelf smsCodeRequestSuccess];
        }
    }];
}



#pragma mark - 验证码获取成功后执行
- (void)smsCodeRequestSuccess
{
    self.verfiCodeBtn.enabled = NO;
    self.verfiCodeBtn.backgroundColor = [UIColor lightGrayColor];
    self.smsDownSeconds = 60;
    
    self.smsDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downTimeWithSeconds:) userInfo:nil repeats:YES];
    [self.smsDownTimer fire];
    
}

- (void)downTimeWithSeconds:(NSTimer *)timer
{
    if (self.smsDownSeconds ==0)
    {
        self.verfiCodeBtn.enabled = NO;
        self.verfiCodeBtn.backgroundColor = [UIColor orangeColor];
        [self.verfiCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsDownTimer invalidate];
    }
    else
    {
           [self.verfiCodeBtn setTitle:[[NSNumber numberWithInt:(int)self.smsDownSeconds] description] forState:UIControlStateNormal];
        self.smsDownSeconds--;
    }
}

- (IBAction)registerAction:(UIButton *)sender {
    
    [self validatePhoneAndPassword];
}


- (void)validatePhoneAndPassword
{
    NSString *mobilePhoneNumer = [NSString zhFilterInputTextWithWittespaceAndLine:self.userNameField.text];
    NSString *passwordError = [UITextField zhu_TextFieldPassword:self.passwordField.text];
    if (![UITextField zhu_validatePhoneNumber:mobilePhoneNumer])
    {
        [self zhHUD_showErrorWithStatus:@"您输入的手机号码错误，请核实后重新输入"];
    }
    else if ([NSString zhFilterInputTextWithWittespaceAndLine:self.verificationCodeField.text].length==0)
    {
         [self zhHUD_showErrorWithStatus:@"请输入验证码"];
    }
    else if (passwordError.length>0)
    {
        [self zhHUD_showErrorWithStatus:passwordError];
        
    }
    else if (![self.passwordField.text isEqualToString:self.passwordAgainField.text])
    {
         [self zhHUD_showErrorWithStatus:@"二次密码不一样，请重新输入"];
    }
    else
    {
        [[UIApplication sharedApplication]sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
      
        
        [self zhHUD_showHUDAddedTo:self.view labelText:@"正在注册"];
        [self findAccountIsRegister];
    }
}


#pragma mark - 请求判断这个手机号是否已经注册过

- (void)findAccountIsRegister
{
    WS(weakSelf);
    
    
    BmobQuery *query = [BmobQuery queryForUser];
    [query whereKey:@"username" equalTo:self.userNameField.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error)
        {
            NSLog(@"%@",[error localizedDescription]);
        }
        else
        {
            if (array.count>0)
            {
                [weakSelf zhHUD_showErrorWithStatus:@"这个手机号已经注册过了"];
            }
            else
            {
                [weakSelf registerAccount];
            }
            
        }
    }];

}


#pragma mark - 注册

- (void)registerAccount
{
    
    WS(weakSelf);

    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:self.userNameField.text SMSCode:self.verificationCodeField.text andPassword:self.passwordField.text block:^(BmobUser *user, NSError *error) {
        
        if (user)
        {
            NSLog(@"注册成功：%@",user);
            
            UserModel *userModel = [[UserModel alloc] init];
            userModel.userId = @([user.objectId integerValue]);
            userModel.phone = user.mobilePhoneNumber ;
            userModel.username = user.username;
            [UserInfoUDManager setUserData:userModel];
            [UserInfoUDManager loginIn];

            [weakSelf zhHUD_showSuccessWithStatus:@"注册成功"];
            
            [weakSelf performSelector:@selector(registerSuccess) withObject:nil afterDelay:2.f];
            
        }
        else
        {
            [weakSelf zhHUD_showErrorWithStatus:@"验证码有误"];
        }
    }];

}

- (void)registerSuccess
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 用户协议

- (IBAction)userAgreementAction:(UIButton *)sender {
    
    FullTextViewController *textViewVC = [[FullTextViewController alloc] initWithBarTitle:@"用户服务协议"];
    [textViewVC loadUserServiceAgreementPathOfResource:@"UserServiceAgreement" ofType:@"txt" company:@"美颜拼图公司" appName:APP_Name];
    [self.navigationController pushViewController:textViewVC animated:YES];
}
@end
