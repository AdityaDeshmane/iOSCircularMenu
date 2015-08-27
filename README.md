iOSCircularMenu
===============

Circular style menu


![      ](\circularMenu.gif "") 


### Features

* Generic code 
* Easy to modify 

<em>This UI control can be used on all iPhones, iPods & iPads running iOS 5.0 and above.</em>

---
---

### Adding to your project


* Add Follwing two files to your project

```
'ADCircularMenuViewController.h'
'ADCircularMenuViewController.m'
```

---
---

### How to use

#### Sample Codes

```obj-c

//1.  IMPORT
#import "ADCircularMenuViewController.h"



//2. CREATING INSTANCE OF CONTROL

    //creat image name array for menu buttons
    //use 3 or 7 or 12 for symmetric look (current implementation supports max 12 buttons)
    NSArray *arrImageName = [[NSArray alloc] initWithObjects:@"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu",
                             @"btnMenu", nil];
    
   ADCircularMenuViewController *circularMenuVC = [[ADCircularMenuViewController alloc] initWithMenuButtonImageNameArray:arrImageName andCornerButtonImageName:@"btnMenuCorner"];                                                    
   circularMenuVC.delegateCircularMenu = self;


//3. SHOWING MENU

    [circularMenuVC show];
    


//4. CONFORM TO PROTOCOL
<ADCircularMenuDelegate> //contains only one menu button click optinal method



//5. HANDLE DELEGATE METHODS

- (void)circularMenuClickedButtonAtIndex:(int) buttonIndex
{
    NSLog(@"Clicked menu button at index : %d",buttonIndex);
}

```


---
---

### Requirements

ADCircularMenuViewController works on iOS 5.0 & above versions and is compatible with ARC projects. There is no need of other frameworks/libraries

---
---

### Other details

* XCode : Developed using 6.0
* Base sdk used while development : 8.0
* Testing : iOS: 6,7,8   Devices : iPad & 3.5, 4, 4.7, 5.5 inch iphones

---
---

### TODO

* More customisation options
* Component polishing

---
---

## License

iOSCircularMenu is available under the MIT license. See the LICENSE file for more info.