iOSCircularMenu
===============

Circular style menu


![      ](/circularMenu.gif "") 


### Features

* Smooth animations
* Tapping non button area closes menu
* Tap on Corner button again to close menu
* Generic & small code 
* Easy to modify as per requirements
* Customisation options like corner button images, menu buttons image, animation speed, button widths, distance between concentric circles ( provides as #defines )

<em>This UI control can be used on all iPhones, iPods & iPads running iOS 5.0 and above.</em>

---
---

### Adding to your project


Just add Follwing two files to your project

```
'ADCircularMenu.h'
'ADCircularMenu.m'
```

---
---

### How to use ?

Refer following sample code / refer demo application.

#### Sample Code

```obj-c

//1.  IMPORT

#import "ADCircularMenu.h"


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
    
   ADCircularMenu *circularMenuVC = [[ADCircularMenu alloc] initWithMenuButtonImageNameArray:arrImageName andCornerButtonImageName:@"btnMenuCorner"];                                                    
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

ADCircularMenu works on iOS 5.0 & above versions and is compatible with ARC projects. There is no need of other frameworks/libraries

---
---

### Other details

* Testing : iOS: 5, 6, 7, 8, 9.0 Beta   
* Devices : iPad & 3.5, 4, 4.7, 5.5 inch iphones

---
---

### TODO

* More customisation options
* Component polishing
* Validations
* Show menu from any point in view

---
---

## License

iOSCircularMenu is available under the MIT license. See the LICENSE file for more info.
