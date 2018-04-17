//
//  AWRActionSheetView.m
//  AWRActionSheetViewDemo
//
//  Created by Long on 2018/4/16.
//  Copyright © 2018年 LongJun. All rights reserved.
//

#import "AWRActionSheetView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define MARGIN 10.0
#define ACTION_SHEET_WIDTH  SCREEN_WIDTH - (MARGIN * 2)
#define DEFAULT_SYS_BTN_COLOR [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0] //系统默认按钮的颜色（接近蓝色的那个颜色）
#define FONT_TITLE          [UIFont systemFontOfSize:18]
#define FONT_TITLE_BOLD     [UIFont boldSystemFontOfSize:18]
#define FONT_SUBTITLE       [UIFont systemFontOfSize:12]

@implementation AWRActionSheetItem

+ (instancetype)actionWithTitle:(nullable NSString *)title
{
    return [AWRActionSheetItem actionWithSubtitle:title subtitle:nil];
}
+ (instancetype)actionWithSubtitle:(nullable NSString *)title
                          subtitle:(NSString*)subtitle
{
    return [AWRActionSheetItem actionWithSubtitle:title subtitle:subtitle titleStyle:AWRActionItemTitleStyleDefault];
}
+ (instancetype)actionWithTitle:(nullable NSString *)title
                     titleStyle:(AWRActionItemTitleStyle)titleStyle
{
    return [AWRActionSheetItem actionWithSubtitle:title subtitle:nil titleStyle:titleStyle];
}
+ (instancetype)actionWithSubtitle:(nullable NSString *)title
                          subtitle:(NSString*)subtitle
                        titleStyle:(AWRActionItemTitleStyle)titleStyle
{
    return [AWRActionSheetItem actionWithIcon:nil title:title subtitle:subtitle titleStyle:titleStyle];
}
+ (instancetype)actionWithIcon:(UIImage*)icon
                         title:(nullable NSString *)title
                      subtitle:(NSString*)subtitle
                    titleStyle:(AWRActionItemTitleStyle)titleStyle
{
    AWRActionSheetItem *item = [[AWRActionSheetItem alloc] init];
    item.iconImage = icon;
    item.title = title;
    item.subtitle = subtitle;
    item.titleStyle = titleStyle;
    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enabled = YES;
    }
    return self;
}

@end


@interface AWRActionSheetView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat tableCellHeight;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *cancelText;
@property (nonatomic, strong) NSMutableArray<AWRActionSheetItem*> *actionItems;
@property (nonatomic,   copy) void(^ __nullable cancelBlock)(void);
@property (nonatomic,   copy) void(^ __nullable selectedBlock)(NSInteger selectedIndex, AWRActionSheetItem *actionItem);


@end


@implementation AWRActionSheetView

#pragma mark - Class life cycle

- (instancetype)initWithTitle:(NSString*)title
                      message:(NSString*)message
                  actionItems:(NSArray<AWRActionSheetItem*>*)actionItems
                   cancelText:(NSString*)cancelText
{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.actionItems = [NSMutableArray arrayWithArray:actionItems];
        self.cancelText = cancelText;
        
        [self craetUI];
        [self.tableView reloadData];
    }
    return self;
}

- (instancetype)initWithCustomHeadView:(UIView*)headView
                           actionItems:(NSArray<AWRActionSheetItem*>*)actionItems
                            cancelText:(NSString*)cancelText
{
    if (self = [super init]) {
        self.headView = headView;
        self.actionItems = [NSMutableArray arrayWithArray:actionItems];
        self.cancelText = cancelText;
        
        [self craetUI];
        [self.tableView reloadData];
    }
    return self;
}


#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (_actionItems)?_actionItems.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headView ? _headView.bounds.size.height : 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _headView ? _headView : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableCellHeight;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else {
        for (UIView *v in cell.contentView.subviews)
        {
            [v removeFromSuperview];
        }
    }
    
    AWRActionSheetItem *item = _actionItems[indexPath.row];
    
    // Calculate title/subtitle text size
    UIFont *titleFont = item.titleStyle == AWRActionItemTitleStyleCancel ? FONT_TITLE_BOLD : FONT_TITLE;
    CGSize titleTextSize = [item.title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
    CGSize subtitleTextSize;
    if (item.subtitle && item.subtitle.length > 0)
        subtitleTextSize = [item.subtitle sizeWithAttributes:@{NSFontAttributeName:FONT_SUBTITLE}];
    else
        subtitleTextSize = CGSizeMake(0, 0);
    CGSize maxWidthTextSize = subtitleTextSize.width > titleTextSize.width ? subtitleTextSize : titleTextSize;
    
    // icon image
    CGFloat iconW = 24;
    if (item.iconImage) {
        UIImageView *iconImg = [[UIImageView alloc] initWithImage:item.iconImage];
        iconImg.frame = CGRectMake((ACTION_SHEET_WIDTH - (iconW + MARGIN + maxWidthTextSize.width)) / 2,
                                   (self.tableCellHeight - iconW) / 2,
                                   iconW,
                                   iconW);
        [cell.contentView addSubview:iconImg];
    }
    
    // title
    CGRect rect;
    CGFloat y = (item.subtitle && item.subtitle.length > 0) ? MARGIN : (self.tableCellHeight - titleTextSize.height) / 2;
    if (item.iconImage) {
        rect = CGRectMake((ACTION_SHEET_WIDTH - (iconW + MARGIN + maxWidthTextSize.width)) / 2 + iconW + MARGIN,
                          y,
                          titleTextSize.width,
                          titleTextSize.height);
    }
    else {
        rect = CGRectMake((ACTION_SHEET_WIDTH - titleTextSize.width)/2,
                          y,
                          titleTextSize.width,
                          titleTextSize.height);
    }
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:rect];
    lblTitle.text = item.title;
    lblTitle.font = titleFont;
    if (item.titleStyle == AWRActionItemTitleStyleDestructive)
        lblTitle.textColor = [UIColor redColor];
    else
        lblTitle.textColor = DEFAULT_SYS_BTN_COLOR;
    lblTitle.enabled = item.enabled;
    [cell.contentView addSubview:lblTitle];
    
    // subtitle
    if (item.subtitle && item.subtitle.length > 0) {
        if (item.iconImage) {
            rect = CGRectMake((ACTION_SHEET_WIDTH - (iconW + MARGIN + maxWidthTextSize.width)) / 2 + iconW + MARGIN,
                              lblTitle.frame.origin.y + lblTitle.frame.size.height + 2,
                              subtitleTextSize.width,
                              subtitleTextSize.height);
        }
        else {
            rect = CGRectMake((ACTION_SHEET_WIDTH - subtitleTextSize.width)/2,
                              lblTitle.frame.origin.y + lblTitle.frame.size.height + 2,
                              subtitleTextSize.width,
                              subtitleTextSize.height);
        }
        UILabel *lblSubTitle = [[UILabel alloc] initWithFrame:rect];
        lblSubTitle.text = item.subtitle;
        lblSubTitle.font = FONT_SUBTITLE;
        lblSubTitle.textColor = [UIColor lightGrayColor];
        //        lblSubTitle.textColor = [UIColor darkGrayColor];
        lblSubTitle.enabled = item.enabled;
        [cell.contentView addSubview:lblSubTitle];
        
    }
    
    cell.userInteractionEnabled = item.enabled;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //让表格的分割线左侧顶到头
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (self.selectedBlock) {
            AWRActionSheetItem *item = _actionItems ? _actionItems[indexPath.row] : nil;
            self.selectedBlock(indexPath.row, item);
        }
    } else {
        if (self.cancelBlock) self.cancelBlock();
    }
    [self dismiss];
}


#pragma mark - Private method

- (UIView*)createHeadView:(NSString*)title msg:(NSString*)msg {
    
    if (!title) return nil;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ACTION_SHEET_WIDTH, 1)];
    containerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat totalH = 0;
    CGFloat topBottomMargin = 10;
    
    //title
    UIFont *font = [UIFont systemFontOfSize:16];
    CGSize textSize =[title sizeWithAttributes:@{NSFontAttributeName:font}];
    CGRect rect = CGRectMake((containerView.frame.size.width-textSize.width)/2,
                             topBottomMargin,
                             textSize.width,
                             textSize.height);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
    titleLabel.text = title;
    titleLabel.font = font;
    titleLabel.textColor = [UIColor colorWithRed:73/255.0 green:75/255.0 blue:90/255.0 alpha:1];
    [containerView addSubview:titleLabel];
    totalH += titleLabel.frame.origin.y + titleLabel.frame.size.height;
    
    //message
    if (msg && msg.length > 0) {
        UIFont *font = [UIFont systemFontOfSize:12];
        CGSize textSize = [msg boundingRectWithSize:CGSizeMake(ACTION_SHEET_WIDTH - MARGIN*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
        CGRect rect = CGRectMake((containerView.frame.size.width-textSize.width)/2,
                                 titleLabel.frame.origin.y + titleLabel.frame.size.height + 5,
                                 textSize.width,
                                 textSize.height);
        UILabel *descLabel = [[UILabel alloc]initWithFrame:rect];
        descLabel.numberOfLines = 0;
        descLabel.text = msg;
        descLabel.font = font;
        descLabel.textColor = [UIColor lightGrayColor];
        [containerView addSubview:descLabel];
        totalH = descLabel.frame.origin.y + descLabel.frame.size.height;
    }
    
    //add bottom margin
    totalH += topBottomMargin;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                           totalH,
                                                           containerView.frame.size.width,
                                                           .5)];
    line.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [containerView addSubview:line];
    totalH += line.frame.size.height;
    
    //
    containerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, totalH);
    
    return containerView;
}

- (void)craetUI {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.maskView];
    [self addSubview:self.tableView];
    [self addSubview:self.bottomView];
    
    //
    if (!_headView && _title) {
        self.headView = [self createHeadView:_title msg:_message];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (UIView*)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = .5;
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        _tableView.clipsToBounds = YES;
        //        _tableView.rowHeight = 44.0;
        _tableView.rowHeight = self.tableCellHeight;
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        //        _tableView.tableHeaderView = self.headView;
        //        _tableView.separatorInset = UIEdgeInsetsMake(0, -50, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;
        
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
            
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (UIView*)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MARGIN*2 + self.tableCellHeight) ];
        
        
        // space view
        UIView *spaceView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, MARGIN)];
        spaceView1.backgroundColor = [UIColor clearColor];
        spaceView1.alpha = 0;
        [_bottomView addSubview:spaceView1];
        
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      spaceView1.frame.origin.y + spaceView1.frame.size.height,
                                                                      ACTION_SHEET_WIDTH,
                                                                      self.tableCellHeight)];
        cancelView.backgroundColor = [UIColor whiteColor];
        cancelView.layer.cornerRadius = 10;
        [_bottomView addSubview:cancelView];
        
        // text label
        NSString *textStr = self.cancelText;
        UIFont *font = [UIFont boldSystemFontOfSize:18];
        CGSize textSize =[textStr sizeWithAttributes:@{NSFontAttributeName:font}];
        CGRect rect = CGRectMake((cancelView.frame.size.width-textSize.width)/2,
                                 (cancelView.frame.size.height-textSize.height)/2,
                                 textSize.width,
                                 textSize.height);
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:rect];
        lblTitle.text = textStr;
        lblTitle.font = font;
        lblTitle.textColor = DEFAULT_SYS_BTN_COLOR;
        [cancelView addSubview:lblTitle];
        
        // space view
        UIView *spaceView2 = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                      cancelView.frame.origin.y + cancelView.frame.size.height,
                                                                      spaceView1.frame.size.width, MARGIN)];
        spaceView2.backgroundColor = [UIColor clearColor];
        spaceView2.alpha = 0;
        [_bottomView addSubview:spaceView2];
    }
    return _bottomView;
}





- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.cancelBlock) self.cancelBlock();
    [self dismiss];
}

- (CGFloat)tableCellHeight {
    if (!_tableCellHeight) {
        if (!_actionItems || _actionItems.count < 1) {
            _tableCellHeight = 48; //44;
        }
        else {
            BOOL haveSubtitle = NO;
            for (AWRActionSheetItem *item in _actionItems) {
                if (item.subtitle && item.subtitle.length > 0) {
                    haveSubtitle = YES;
                    break;
                }
            }
            if (haveSubtitle)
                _tableCellHeight = 58.0;
            else
                _tableCellHeight = 48; //44.0;
        }
    }
    return _tableCellHeight;
}


#pragma mark - Public method

//- (void)addActionItem:(AWRActionSheetItem*)actionItem {
//    if (!_actionItems) _actionItems = [[NSMutableArray<AWRActionSheetItem*> alloc] init];
//    [self.actionItems addObject:actionItem];
//}

- (void)show:(void(^ __nullable)(void))cancelBlock
selectedBlock:(void(^ __nullable)(NSInteger selectedIndex, AWRActionSheetItem *actionItem))selectedBlock
{
    self.cancelBlock = cancelBlock;
    self.selectedBlock = selectedBlock;
    
    NSInteger rows = _actionItems ? _actionItems.count : 0;
    CGFloat headViewH = _headView ? _headView.bounds.size.height : 0;
    CGFloat tableH = _tableView.rowHeight * rows + headViewH;
    CGFloat top_blank_h = (SCREEN_HEIGHT/9*1);
    CGFloat maxTableH = SCREEN_HEIGHT - top_blank_h - _bottomView.frame.size.height;
    if (tableH > maxTableH) tableH = maxTableH;
    CGFloat bottomH = _bottomView.bounds.size.height;
    
    _tableView.frame = CGRectMake(MARGIN,
                                  SCREEN_HEIGHT,
                                  ACTION_SHEET_WIDTH, tableH);
    _bottomView.frame = CGRectMake(MARGIN,
                                   _tableView.frame.origin.y + _tableView.frame.size.height,
                                   _bottomView.bounds.size.width,
                                   bottomH);
    
    //
    [UIView animateWithDuration:.25 animations:^{
        
        CGRect rect = self.tableView.frame;
        CGFloat yLen = 0;
        if (@available(iOS 11.0, *)) {
            yLen = tableH + bottomH + [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        } else {
            yLen = tableH + bottomH;
        }
        rect.origin.y -= yLen;
        self.tableView.frame = rect;
        
        CGRect rect2 = self.bottomView.frame;
        rect2.origin.y -= yLen;
        self.bottomView.frame = rect2;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:.25 animations:^{
        CGRect rect = self.tableView.frame;
        CGFloat yLen = 0;
        if (@available(iOS 11.0, *)) {
            yLen = self.tableView.bounds.size.height + self.bottomView.bounds.size.height + [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        } else {
            yLen = self.tableView.bounds.size.height + self.bottomView.bounds.size.height;
        }
        rect.origin.y += yLen;
        self.tableView.frame = rect;
        
        CGRect rect2 = self.bottomView.frame;
        rect2.origin.y += yLen;
        self.bottomView.frame = rect2;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (CGFloat)defaultActionSheetWidth {
    return ACTION_SHEET_WIDTH;
}


@end

