//
//  AWRActionSheetView.h
//  AWRActionSheetViewDemo
//
//  Created by Long on 2018/4/16.
//  Copyright © 2018年 LongJun. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Action item font and color style
 */
typedef NS_ENUM(NSInteger, AWRActionItemTitleStyle) {
    AWRActionItemTitleStyleDefault = 0, //The action item title text font color is blue.
    AWRActionItemTitleStyleCancel,      //The action item title text font color is bold blue.
    AWRActionItemTitleStyleDestructive  //The action item title text font color is red.
};

/**
 * Action item class
 */
@interface AWRActionSheetItem: NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title;
+ (instancetype)actionWithSubtitle:(nullable NSString *)title
                          subtitle:(NSString*)subtitle;
+ (instancetype)actionWithTitle:(nullable NSString *)title
                     titleStyle:(AWRActionItemTitleStyle)titleStyle;
+ (instancetype)actionWithSubtitle:(nullable NSString *)title
                          subtitle:(NSString*)subtitle
                        titleStyle:(AWRActionItemTitleStyle)titleStyle;
+ (instancetype)actionWithIcon:(UIImage*)icon
                         title:(nullable NSString *)title
                      subtitle:(NSString*)subtitle
                    titleStyle:(AWRActionItemTitleStyle)titleStyle;

@property (nullable, nonatomic, strong) UIImage *iconImage;
@property (nonnull, nonatomic, strong) NSString *title;
@property (nullable, nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) AWRActionItemTitleStyle titleStyle;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@property (nonatomic, assign) NSInteger tag;
@property (nullable, nonatomic, strong) NSObject *userData;

@end



/**
 * Action sheet view
 */
@interface AWRActionSheetView : UIView

- (instancetype)initWithTitle:(nullable NSString*)title
                      message:(nullable NSString*)message
                  actionItems:(nullable NSArray<AWRActionSheetItem*>*)actionItems
                   cancelText:(nonnull NSString*)cancelText;

- (instancetype)initWithCustomHeadView:(nullable UIView*)headView
                           actionItems:(nullable NSArray<AWRActionSheetItem*>*)actionItems
                            cancelText:(nonnull NSString*)cancelText;


/**
 * Display action sheet view
 * @param cancelBlock cancel callback block
 * @param selectedBlock selected callback block
 */
- (void)show:(void(^ __nullable)(void))cancelBlock
selectedBlock:(void(^ __nullable)(NSInteger selectedIndex, AWRActionSheetItem *actionItem))selectedBlock;

/**
 * remove action sheet view
 */
- (void)dismiss;

/**
 * get default action sheet view width
 */
+ (CGFloat)defaultActionSheetWidth;

@end
