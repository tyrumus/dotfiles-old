# LegoStax's Dotfiles

This v2.0 branch will be developed later in 2018. I have a lot of projects that have deadlines right now. Plus, I need to get lots of ideas to make an entirely new experience that integrates better, provides more relevant information, etc.

In the meantime, check out the planned features below, or [head back to the master stable branch](https://github.com/legostax/dotfiles)

Dependencies: AwesomeWM, mpd, Pulseaudio

3/4 Wallpapers were found browsing the interwebs.  The Daft Punk one was made by one of my [buddies](https://twitter.com/VoltivTV).  I probably don't have the rights to distribute those other 3 wallpapers.  But, who cares?  Not anyone who's looking for dotfiles.

## Features
- Multi-monitor support
- Animations via `tween.lua`
- Custom integrated lockscreen
- Music (MPD) integration. I quit developing the custom python music server because it used a lot of weird hacks that didn't work 100% of the time.
- Scalable app menu entries
- Other aesthetically pleasing things
- Quite a few keyboard shortcuts
- [Check out some screenies](http://imgur.com/gallery/E9dQ0)

## Setup/Installation

- Install AwesomeWM 4.2
- Clone this repository into `~/.config/awesome/`
- Edit `themes/default/theme.lua` to match the location of your `~/.config/awesome`
- Make changes to the audio input setup to ensure that the music player will work with your audio setup
- Change the `screenLockPin` to something other than the default **1234**

Right-click on the desktop and click Hotkeys to see a list of all of the keybinds.

Ensure your `~/.face` is at least 400x400 in size for the lockscreen to look right.

Poke around for other things to tweak to your liking. Have fun!
