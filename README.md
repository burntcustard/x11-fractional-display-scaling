# x11-fractional-display-scaling
Script and instructions to get fractional display scaling working nicely on Linux distros using X11 (i.e. X.Org).

**Many** people are having issues with high (arguably *medium*) resolution screens and Linux. Some distros only have hidden settings, some only have integer scaling (x2, 4x), some have fractional scaling but it's garbage.

This technique uses an (I think) X11-specific workaround with xrandr to make everything a comfortable size. It sets scaling to 2x, making everything massive, and then shrinks it back down again to 1.5x or whatever you want by "zooming out". It was originally written **for Ubuntu 17.10**. It *should* work for any Linux distro with an X11 display server, but might need tweaking for not-Ubuntu or not-Gnome.


## How to
1. Download [display_scale.sh](https://github.com/burntcustard/x11-fractional-display-scaling/blob/master/display_scale.sh) and put it somewhere like your documents folder.

2. If you're not sure what display server's running:
   ```
   $ echo $XDG_SESSION_TYPE
   ```
   
3. If you're on Wayland on Ubuntu it's easy to switch to X11. Open up this config file with whatever text editor.
   ```
   $ sudo nano /etc/gdm3/custom.conf
   ```
   and remove the '#' that comments out this line:
   ```
   #WaylandEnable=false
   ```
   If you can't find that file, try looking in /etc/gdm/
   
4. Get X11 up by re-loging-in or ALT+F2 then r then enter.

5. Set Gnomes display scaling to 2x. This makes everything really big.
   ```
   $ gsettings set org.gnome.desktop.interface scaling-factor 2
   ```
   
6. Run display_scale.sh. Try different sizes with the number at the end. 1 is what you have right now (big), 2 is the same size you had before setting 2x display scaling in the last step (but at 2x render scale so it'll look fancier and use more resources).
   ```
   $ ./Documents/display_scale.sh 1.5
   ```
   
7. Get the script running at startup. In Ubuntu it's easiest with 'Startup Application Preferences'. In the command text field put in this, with the number you decided upon earlier (or none if you're happy with 1.5x):
   ```
   /home/your-username/Documents/display_scale.sh
   ```


## Q/A


#### What's display_scale_fix for / HELP! Sometimes everything goes tiny!
When I (burntcustard) open my laptop lid (not when I suspend, reboot, or close the lid... literally *when it opens*), scaling breaks.

display_scale_fix.sh runs display_scale.sh twice, first to set it to 1, and then whatever number you specify. It's helping me out for now, but I hope there's a better way someone can find, or it automagically gets fixed. I have the script set to a keyboard shortcut with the command:
```
bash /home/your-username/Documents/display_scale_fix.sh
```


#### Why not just run "xrandr --output eDP-1 --scale 1.5x1.5 --panning 2880x1620" at startup?

a) That requires some fiddling to figure out what the name of the display is.

b) That needs some calculatoring to try out different panning numbers.

c) Ain't nobody got time for dat.


#### Using display_scale.sh with >2 doesn't work!
If you're determined you want to do >2 (be warned, larger scales use exponentially more resources), you need to redo step 4 and set the org.gnome.desktop.interface scaling factor to 4 or 8.


#### Does this work for multiple screens?
Short answer: No.

Long answer: No, the script won't work, but if you look *inside* it, you should be able to figure out what it's doing and might be able to apply similar techniques with multiple screens. However... you're likely better off waiting until Waylands scaling has been improved, or dare I say it... use Win10 or OS X because they have much better multi-display scaling options.


#### What's X11 / X.Org, I confuse?
X.Org is a display server that implements the ancient X11 display server protocol. For more info: https://en.wikipedia.org/wiki/Display_server#X11
