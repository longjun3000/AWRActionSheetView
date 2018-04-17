[View English document](https://github.com/longjun3000/AWRActionSheetView/blob/master/README.md "English README.md") 
# AWRActionSheetView
AWRActionSheetView是一个增强型的ActionSheetView，设置不同的参数，可以展现更多的样式，适用于更多的场景。

AWRActionSheetView现有的功能：

1、能够显示标准的UIAlertController的UIAlertControllerStyleActionSheet样式。

2、能够显示带图标的样式。

3、能够显示带子标题的样式。

4、能够自定义头部的View。

5、能够混搭各种显示样式。


## 显示样式
### 1. Show normal （显示常规情况）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot03.png)
### 2. Show normal without head（显示常规情况且没有头部）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot04.png)
### 3. Show normal with custom head view（显示常规情况，并且带有自定义的头部视图）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot05.png)
### 4. Show with icon（显示带图标的情况）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot06.png)
### 5. Show with subtitle（显示带子标题的情况）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot07.png)
### 6. Show with subtitle and icon（显示带子标题和图标的情况）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot08.png)
### 7. Show with item title style（显示带选项标题样式的情况）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot09.png)
### 8. Show with mixed items（显示混合选项的情况）:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot10.png)

# 如何使用？
1、将“AWRActionSheetView.h”和“AWRActionSheetView.”源码文件加入到您的项目工程中。

2、在需要的地方引入头文件：

```
#import "IAWRActionSheetView.h"
```

3、代码例子：

```
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
```

注：更多使用范例请参考源码“AWRActionSheetViewDemo”工程下的“ViewController.m”。



# 联系方式
ArwerSoftware@gmail.com


# License
The MIT License (MIT)

Copyright © 2018 LongJun

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
