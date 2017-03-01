//
//  ZJComposeViewController.m
//  TaurusWeibo
//
//  Created by company on 15/9/18.
//  Copyright (c) 2015年 Taurus. All rights reserved.
//

#import "ZJComposeViewController.h"
#import "ZJTextView.h"
#import "ZJComposeToolBar.h"
#import "ZJComposeViewController.h"
#import "ZJComposePhotosView.h"
#import "ZJHttpTool.h"
#import "ZJUpLoadParam.h"
#import "MBProgressHUD+MJ.h"

@interface ZJComposeViewController () <UITextViewDelegate,ZJComposeToolBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, weak) ZJTextView *textView;
@property (nonatomic, weak) ZJComposeToolBar *toolBar;
@property (nonatomic, weak) ZJComposePhotosView *photosView;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIBarButtonItem *rightItem;


@end

@implementation ZJComposeViewController

- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    
    return _images;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航条
    [self setUpNavgationBar];
    
    // 添加textView
    [self setUpTextView];
    
    //添加工具条
    [self setUpToolBar];
    
    //监听键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 添加相册视图
    [self setUpPhotosView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}

// 添加相册视图
- (void)setUpPhotosView
{
    ZJComposePhotosView *photosView = [[ZJComposePhotosView alloc] initWithFrame:CGRectMake(0, 70, self.view.width, self.view.height - 70)];
    _photosView = photosView;
    [_textView addSubview:photosView];
}

#pragma mark - 键盘的Frame改变的时候调用
- (void)keyboardFrameChange:(NSNotification *)note
{
    //获取键盘弹出的时间
    CGFloat durtion = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //获取键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (frame.origin.y == self.view.height) { // 没有弹出键盘
        [UIView animateWithDuration:durtion animations:^{
            
            _toolBar.transform =  CGAffineTransformIdentity;
        }];
    }else{ // 弹出键盘
        // 工具条往上移动
        [UIView animateWithDuration:durtion animations:^{
            
            _toolBar.transform = CGAffineTransformMakeTranslation(0, -frame.size.height);
        }];
    }

}

#pragma mark - 添加textView
- (void)setUpTextView
{
    ZJTextView *textView = [[ZJTextView alloc] initWithFrame:self.view.bounds];
    _textView = textView;
    textView.placeHolder = @"分享新鲜事...";
    textView.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:textView];
    
     // 默认允许垂直方向拖拽
    textView.alwaysBounceVertical = YES;
    
    //监听文本框的输入
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    
    //监听拖拽代理
    _textView.delegate = self;
}

#pragma mark - 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textChange
{
    //判断是textView否有内容
    if (_textView.text.length) {
        _textView.hidePlaceHolder = YES;
        _rightItem.enabled = YES;
    } else {
        _textView.hidePlaceHolder = NO;
        _rightItem.enabled = NO;
    }
}

#pragma mark - 设置导航条
- (void)setUpNavgationBar
{
    self.title = @"发送微博";
    // left
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(dismiss)];
    
    // right
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(compose) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn sizeToFit];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    rightItem.enabled = NO;
    _rightItem = rightItem;
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)setUpToolBar
{
    CGFloat h = 35;
    CGFloat y = self.view.height - h;
    ZJComposeToolBar *toolBar = [[ZJComposeToolBar alloc] initWithFrame:CGRectMake(0, y, self.view.width, h)];
    _toolBar = toolBar;
    
    toolBar.delegate = self;
    
    [self.view addSubview:toolBar];}

// 发送微博
- (void)compose
{
    if (self.images.count) { //发送图片
        
        [self sendPicture];
    } else {
        
        [self sendTitle];
    }
}

#pragma mark - 发送图片
- (void)sendPicture
{
    UIImage *image = self.images[0];
    NSString *status = _textView.text.length ? _textView.text : @"分享图片";
    _rightItem.enabled = NO;
    
    //创建参数模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = status;
    
    // 创建上传的模型
    ZJUpLoadParam *upLoadParam = [[ZJUpLoadParam alloc] init];
    upLoadParam.data = UIImagePNGRepresentation(image);
    upLoadParam.name = @"pic";
    upLoadParam.fileName = @"image.png";
    upLoadParam.mimeType = @"image/png";
    
    [ZJHttpTool UpLoad:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params upLoadParam:upLoadParam success:^(id responseObject) {
        
        // 提示用户发送成功
        [MBProgressHUD showSuccess:@"发送图片成功"];
        
        // 回到首页
        [self dismissViewControllerAnimated:YES completion:nil];
        _rightItem.enabled = YES;
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error.description);
        [MBProgressHUD showError:@"发送图片失败"];
        _rightItem.enabled = YES;

    }];
}

#pragma mark - 发送文字
- (void)sendTitle
{
    NSString *status= _textView.text;
    _rightItem.enabled = NO;
    
    //创建参数模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = status;

    [ZJHttpTool POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(id responseObject) {
        
        // 提示用户发送成功
        [MBProgressHUD showSuccess:@"发送成功"];
        
        // 回到首页
        [self dismissViewControllerAnimated:YES completion:nil];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showError:@"发送失败"];
    }];
}

#pragma mark - 点击工具条按钮的时候调用
- (void)composeToolBar:(ZJComposeToolBar *)toolBar didClickBtn:(NSInteger)index
{
    if (index == 0) { // 点击相册
        // 弹出系统的相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // 设置相册类型,相册集
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }
}

#pragma mark - 选择图片完成的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 获取选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.images addObject:image];
    _photosView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    _rightItem.enabled = YES;

}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
