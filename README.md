[查看中文文档](https://github.com/longjun3000/AWRActionSheetView/blob/master/README-CN.md "Chinese README.md") 
# AWRActionSheetView
AWRActionSheetView is an enhanced ActionSheetView, set different parameters, can show more styles, apply to more scenarios.

AWRActionSheetView existing features:

1. It can display the standard UIAlertControllerStyleActionSheet style of the UIAlertController.

2. It can display the style with icons.

3. It can display the style with subtitles.

4. It can customize the view of the head.

5. It can mix various display styles.

## Display style
### 1. Show normal:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot03.png)
### 2. Show normal without head:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot04.png)
### 3. Show normal with custom head view:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot05.png)
### 4. Show with icon:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot06.png)
### 5. Show with subtitle:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot07.png)
### 6. Show with subtitle and icon:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot08.png)
### 7. Show with item title style:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot09.png)
### 8. Show with mixed items:
![image](https://raw.githubusercontent.com/longjun3000/AWRActionSheetView/master/Screenshot/iOS/Screenshot10.png)

# How to use ?

1. Add the "AWRActionSheetView.h" and "AWRActionSheetView.m" source files to your project.

2. Import header files where necessary:

```
#import "AWRActionSheetView.h"
```

3. Code usage example:

```
/**
 * Show normal
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

Note: for more examples, please refer to "ViewController.m" under the "AWRActionSheetViewDemo" project.



# Contact
ArwerSoftware@gmail.com


# License
The MIT License (MIT)

Copyright © 2018 LongJun

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
