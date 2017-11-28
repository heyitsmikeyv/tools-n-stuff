# Logitech MX Master Bindings
## Make better use of your fancy mouse buttons on Linux

This guide is not exhaustive. It's my current working config on my daily driver (currently running Ubuntu GNOME 17.04) and I haven't personally tested it elsewhere. 

The use of **xbindkeys** to call a bash script which then fires keypresses via **xte** is admittedly hacky. There are allegedly more elegant solutions but I had significantly less success until I used this implementation. 


----------
### What are we doing?
I've been using the [Logitech MX Master](https://www.amazon.com/Logitech-Master-Wireless-Mouse-High-precision/dp/B00TZR3WRM) mouse for a little while, and it's been great for the most part. However, the back/forward buttons next to the horizontal scroll wheel as well as the thumbpad "gesture button" weren't really suiting my needs, and a lack of easy customization was bothersome.

![Logitech MX Master Diagram from Logitech's support site](http://www.logitech.com/assets/53449/2/mx-master-and-logitech-options.jpg)
Image source: http://support.logitech.com/en_us/product/mx-master/faq

The first step we'll be looking at is configuring the gesture button. This is easy enough, because out of the box it fires keyboard keypresses instead of mouse button inputs.

The forward/backward buttons, however, send signals for "button 8" and "button 9", which we'll need to remap for our purposes. The bulk of this guide focuses on these.

----------
### Configuring the Gesture Button

Super easy. The button sends the keystroke combination `Ctrl+Alt+Tab`. Just set up a keyboard shortcut in your Settings configuration that does what you want. You'll likely need to disable the default "Switch system controls" behavior to free up this combo.

For this button, I personally like using "Hide all normal windows" (the wording may differ based on your current distribution and desktop environment). This minimizes all of the windows currently open and shows your desktop. Great for clearing up screen clutter or usage as a panic button when someone's looking over your shoulder.

-----
### Configuring the Forward/Back Buttons

As I mentioned above, the forward and back buttons on the mouse send "button 9" and "button 8" inputs respectively. These are a little tougher to remap and need a couple of 

#### Dependencies

You'll need to ensure you have the following utilities installed:

 - xte
 - xbindkeys

This can be accomplished with `sudo apt install xte xbindkeys`.

----------

#### Creating your button map
Your first step is to create a file in your home directory called `.xbindkeysrc`. This is a magic file that contains your custom mouse button commands to be handled by xbindkeys. You can use the exact version that I have in this repository or create one from scratch.

The version in this repo looks like this:
```
"$HOME/.mxkeypress 8"
	b:8 + release
"$HOME/.mxkeypress 9"
	b:9 + release
```

This tells xbindkeys to execute a script called `.mxkeypress` in your home directory with an argument of "8" or "9" depending on the button pressed and released. Our next step is to create this file.

>**Note:** This is where things get hacky. I create a script that gets called by xbindkeys instead of having it directly run other commands because otherwise it has a bad habit of firing the command twice or not at all. I have no idea why this is the case, but this way works reliably for me.


----------
#### Translating Button Presses To Keyboard Combos
Now we create the script that gets executed by xbindkeys. Again, you can use the `.mxkeypress` script already in this repository or create your own from scratch inside your home directory.

My version of the script looks like this:
```
#!/bin/bash
if [[ $1 == "8" ]]; then
xte 'key Super_L'
elif [[ $1 == "9" ]]; then
xte 'keydown Control_L' 'keydown Alt_L' 'key Down' 'keyup Alt_L' 'keyup Control_L'
fi
```

This `if` statement executes `xte` commands based on the argument passed to the script. You can look into the syntax of these commands with `man xte` if you'd like to get fancy with it and customize further.

For our purposes, button 8 is remapped to `Super_L`, which is usually the Windows or Option key on most keyboards. Button 9 ends up mapping to `Ctrl+Alt+Down`. 

Make the script executable before proceeding with `chmod +x .mxkeypress`.


----------
#### Configuring Hotkeys
So now we've got these extra mouse buttons doing useful keystrokes, it's just a matter of setting up the keyboard hotkeys to do what you want. 

For button 8, the default behavior in GNOME when pressing `Super_L` is to sort of "zoom out" where you can see all of your open windows and click on one to activate. I like this a lot because now I can quickly navigate between a lot of windows without touching the keyboard. However, you're obviously free to modify `.mxkeypress` to send any combination of keystrokes you like and use a different custom hotkey.

Button 9, which sends `Ctrl+Alt+Down` in my example, needs a hotkey configured from within the keyboard settings dialog. I have this hotkeyed to move down one workspace, which works great as a workspace toggle when you use 2 workspaces and enable wrapping during switching.

---------------
#### Adding to Startup
Lastly, make sure that `xbindkeys` is configured to run on startup. You can do this however you like, but I prefer just using the built-in Startup Applications dialog. For your first run, you can simply run `xbindkeys` from a command line. 

