//
//  ViewController.m
//  AWRActionSheetViewDemo
//
//  Created by Long on 2018/4/16.
//  Copyright © 2018年 LongJun. All rights reserved.
//

#import "ViewController.h"
#import "AWRActionSheetView.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *customHead;
@property (nonatomic, assign) BOOL isRemember;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

/**
 * Show iOS System Native UIAlertController
 * 显示iOS系统原生UIAlertController
 */
- (IBAction)showSysNativeUIAlertControllerAction:(id)sender {
    
    NSString *title = @"This is title";
    NSString *message = @"Custom message content, custom message content custom message content.";
    
    // cancel button
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@">>> Click the cancel button.");
    }];
    [alertController addAction:cancelAction];
    
    // other buttons
    for (int i=1; i<20; i++) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Option title %d",i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@">>> Click the other button %d", i);
        }];
        [alertController addAction:otherAction];
    }
    
    //show alert controller
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 * Show normal
 * 显示常规情况
 */
- (IBAction)showNormalAction:(id)sender {
    
    // 1 Prepare params
    NSString *title = @"This is title";
    NSString *message = @"Custom message content, custom message content custom message content.";
    
    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    for (int i=1; i<20; i++) {
        AWRActionSheetItem *item = [AWRActionSheetItem actionWithTitle:[NSString stringWithFormat:@"Option title %d", i]];
        [actionItems addObject:item];
    }
    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithTitle:title
                                                                        message:message
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
        }
     ];//END actionSheet show

}

/**
 * Show normal without head
 * 显示常规情况且没有头部
 */
- (IBAction)showNormalWithoutHeadAction:(id)sender {
    
    // 1 Prepare params
    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    for (int i=1; i<15; i++) {
        AWRActionSheetItem *item = [AWRActionSheetItem actionWithTitle:[NSString stringWithFormat:@"Option title %d", i]];
        [actionItems addObject:item];
    }
    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithTitle:nil
                                                                        message:nil
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
        }
     ];//END actionSheet show
}

/**
 * Show normal with custom head view
 * 显示常规情况，并且带有自定义的头部视图
 */
- (IBAction)showNormalWithCustomHeadAction:(id)sender {
    
    // 1 Prepare params
    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Adobe Acrobat Reader"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Foxit PDF Reader"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"WPS Office"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"PDF Reader"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Good Reader"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Documents by Readdle"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Kindle"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"GoodNotes"]];
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"MarginNote"]];

    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithCustomHeadView:self.customHead
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"Do you remember this choice: %@", self.isRemember ? @"YES" : @"NO");
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
            
            // write this choice to plist or db, etc.
            //...
        }
     ];//END actionSheet show
}

/**
 * Show with icon
 * 显示带图标的情况
 */
- (IBAction)showWithIconAction:(id)sender {
    
    // 1 Prepare params
//    NSString *title = @"This is title";
//    NSString *message = @"Custom message content, custom message content custom message content.";
    
    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    for (int i=1; i<8; i++) {
        int num =[self getRandomNumber:23456789 to:98765432];
        AWRActionSheetItem *item = [AWRActionSheetItem actionWithIcon:[UIImage imageNamed:@"phone.png"]
                                                                title:[NSString stringWithFormat:@"Call 130%d", num]
                                                             subtitle:nil
                                                           titleStyle:AWRActionItemTitleStyleDefault];
        [actionItems addObject:item];
    }
    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithTitle:nil
                                                                        message:nil
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
        }
     ];//END actionSheet show
    
}

/**
 * Show with subtitle
 * 显示带子标题的情况
 */
- (IBAction)showWithSubtitleAction:(id)sender {
    // 1 Prepare params
    NSString *title = @"This is title";
    NSString *message = @"Custom message content, custom message content custom message content.";
    
    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    for (int i=1; i<15; i++) {
        NSString *title = [NSString stringWithFormat:@"Option title %d", i];
        NSString *subtitle = [NSString stringWithFormat:@"subtitle subtitle, subtitle %d", i];
        AWRActionSheetItem *item = [AWRActionSheetItem actionWithSubtitle:title subtitle:subtitle];
        [actionItems addObject:item];
    }
    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithTitle:title
                                                                        message:message
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
        }
     ];//END actionSheet show
}

/**
 * Show with subtitle and icon
 * 显示带子标题和图标的情况
 */
- (IBAction)showWithSubtitleIconAction:(id)sender {
    
    // 1 Prepare params
    //    NSString *title = @"This is title";
    //    NSString *message = @"Custom message content, custom message content custom message content.";
    
    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    for (int i=1; i<8; i++) {
        AWRActionSheetItem *item = [[AWRActionSheetItem alloc] init];
//        NSString *imgName = [NSString stringWithFormat:@"%d.png", [self getRandomNumber:256 to:263]];
//        item.iconImage = [UIImage imageNamed:imgName];
        item.iconImage = [UIImage imageNamed:@"257.png"];
        item.title = [NSString stringWithFormat:@"Option %d", i];
        item.subtitle = @"subtitle subtitle, subtitle";
//        item.subtitle = @"subtitle";
        [actionItems addObject:item];
    }
    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithTitle:nil
                                                                        message:nil
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
        }
     ];//END actionSheet show
    
}

/**
 * Show with mixed items
 * 显示混合选项的情况
 */
- (IBAction)showWithMixedItemAction:(id)sender {
    // 1 Prepare params
    //    NSString *title = @"This is title";
    //    NSString *message = @"Custom message content, custom message content custom message content.";
    
    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    for (int i=1; i<15; i++) {
        AWRActionSheetItem *item = [[AWRActionSheetItem alloc] init];
        int num = [self getRandomNumber:0 to:5]; //return 0-4
        item.title = [NSString stringWithFormat:@"Option %d", i];
        if (num == 0 || num == 1)
            item.subtitle = @"subtitle subtitle, subtitle";
        else if (num == 2 || num == 3)
            item.iconImage = [UIImage imageNamed:@"257.png"];
        
        if (num % 4 == 0 )
            item.enabled = NO;
        else if (num % 3 == 0 )
            item.titleStyle = AWRActionItemTitleStyleDestructive;
        else if (num % 2 == 0 )
            item.titleStyle = AWRActionItemTitleStyleCancel;
        [actionItems addObject:item];
    }
    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithTitle:nil
                                                                        message:nil
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
        }
     ];//END actionSheet show
}

/**
 * Show with item title style
 * 显示带选项标题样式的情况
 */
- (IBAction)showWithItemTitleStyleAction:(id)sender {
    
    // 1 Prepare params
    NSString *title = @"Which operation do you choose?";
    NSString *message = @"Note: If you choose to delete, you will not be restored after you delete it.";

    NSMutableArray<AWRActionSheetItem*> *actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
    
    //The action item title text font color is red.
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Delete" titleStyle:AWRActionItemTitleStyleDestructive]];
    
    //The action item title text font color is bold blue.
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Move" titleStyle:AWRActionItemTitleStyleCancel]];
    
    //The action item title text font color is blue.
    [actionItems addObject:[AWRActionSheetItem actionWithTitle:@"Rename"]];
    
    
    // 2 Init AWRActionSheetView
    AWRActionSheetView *actionSheet = [[AWRActionSheetView alloc] initWithTitle:title
                                                                        message:message
                                                                    actionItems:actionItems
                                                                     cancelText:@"Cancel"];
    // 3 Show AWRActionSheetView
    [actionSheet show:^{
        NSLog(@"You chose to cancel.");
    }
        selectedBlock:^(NSInteger selectedIndex, AWRActionSheetItem *actionItem) {
            //
            NSLog(@"Do you remember this choice: %@", self.isRemember ? @"YES" : @"NO");
            NSLog(@"You selected index:%ld, title:%@", (long)selectedIndex, actionItem.title);
            
            // write this choice to plist or db, etc.
            //...
        }
     ];//END actionSheet show
    
}


- (UIView *)customHead {
    if (!_customHead) {
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = [UIColor whiteColor];
        
        CGFloat margin = 20;
        CGFloat headWidth = [AWRActionSheetView defaultActionSheetWidth];
        CGFloat totalH = 0;
        
        // left control
        UISwitch *switchCtl = [[UISwitch alloc] initWithFrame:CGRectMake(margin, margin, 51, 31)];
        [switchCtl addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:switchCtl];
        totalH = switchCtl.frame.origin.y + switchCtl.frame.size.height;
        

        // right control
        UILabel *lbl1 = [[UILabel alloc] init];
        UIFont *font = [UIFont boldSystemFontOfSize:16]; //[UIFont systemFontOfSize:12];
        lbl1.text = @"Do you remember this choice?\n(After opening the PDF file, the selected application is used by default.)";
        lbl1.backgroundColor = [UIColor clearColor];
        lbl1.textColor = [UIColor darkGrayColor];
        lbl1.font = font;
        lbl1.numberOfLines = 0;
        CGFloat maxTextWidth = headWidth - switchCtl.frame.size.width - (margin * 3);
        CGSize textSize = [lbl1 sizeThatFits:CGSizeMake(maxTextWidth, MAXFLOAT)];
        CGRect rect = CGRectMake(switchCtl.frame.origin.x + switchCtl.frame.size.width + margin,
                          margin,
                          textSize.width,
                          textSize.height);
        lbl1.frame = rect;
        [containerView addSubview:lbl1];
        
        CGFloat h2 = lbl1.frame.origin.y + lbl1.frame.size.height;
        if (h2 > totalH) totalH = h2;
        totalH += margin;
        
        // line
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               totalH,
                                                               headWidth,
                                                               .5)];
        line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [containerView addSubview:line];
        totalH += line.frame.size.height;
        
        // set containerView frame
        containerView.frame = CGRectMake(0, 0, headWidth, totalH);
        
        //
        _customHead = containerView;
    }
    NSLog(@"headView height=%lf", (_customHead ? _customHead.bounds.size.height : 0));
    return _customHead;
}

- (void)switchAction:(UISwitch*)sender {
    self.isRemember = sender.on;
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
