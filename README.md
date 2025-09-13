# Portaclish
Simply an init.el script for preconfiguring Emacs like [Shinmera's Portacle
IDE](https://portacle.github.io/) configuration.

The project of *a Portable Common Lisp Environment* has [fallen
asleep](https://www.reddit.com/r/Common_Lisp/comments/uphlgw/is_portacle_being_maintained/).

This is less of an issue. It just needed to be there as a helpful inspiration of
how to configure *Emacs* useful as an Integrated Development Envirenment (IDE).

Meanwhile, [Shinmera](https://shinmera.com/) advanced their own Emacs configuration. So, 
professionals and amibitious amateurs may want to checkout 
[this](https://codeberg.org/shinmera/.emacs).

For beginners, this might be a bit too complex. Thus, for pedagogical purposes, and less
advanced needs, this configuration here is meant to be a useful starting point.

The provided ```init.el``` is surely optimisable, but it works -- at least on my
system (Debian Linux). All necessary packages are loaded and configured with
```use-package```. This approach does not result in one system on an USB stick
to be used autonomously on different systems.

But there should be no compatibility issue, no problem with restrictions of
macOS, and the package system of *Emacs* keeps working.  Thus, one dynamic
init.el is portable between fixed regular installations on the respective system
in use.

## Guide

The following is meant for beginners of both, Common Lisp and Emacs.  It is
therefore a bit detailed.  Others don't need it, because they already know what
to do with the source code. 

## Before using the script
[Install *Emacs*](https://www.gnu.org/software/emacs/) according to your OS.

[This describes the process for Windows
11](https://lucidmanager.org/productivity/emacs-windows/). It probably will be
the same on Windows 10.

In general, [this](https://www.gnu.org/software/emacs/download.html#nonfree) is
the GNU description of installing it on Windows (and macOS). 

On Linux and macOS you will just use your distribution's package manager like
*apt* on Debian/Ubuntu, or the package manager of your choice. (BSD Unix users
won't read so far, they already compiled the sources of everything.)

On macOS, [MacPorts](https://www.macports.org/install.php) and
[Homebrew](https://brew.sh/) both provide *Emacs*:
[here](https://ports.macports.org/port/emacs/) and
[here](https://formulae.brew.sh/formula/sbcl). 

For Windows users this might be a nice opportunity to try out the [Windows
Subsystem for Linux
(WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) to use both
operating systems in parallel and enjoy the comfort of a good package management
system. 

**Now, install a *Common Lisp* implementation:** 

[Steel Bank Common Lisp (sbcl)](https://www.sbcl.org/) is the
quasi-standard free *Common Lisp* implementation so to speak.

Of course, Linux users will again use their package manager.

Mac users can also again use [MacPorts](https://ports.macports.org/port/sbcl/),
or [Homebrew](https://formulae.brew.sh/formula/sbcl).

Windows users will probably download the [latest binary for their
system](https://sourceforge.net/projects/sbcl/files/sbcl/) from Sourceforge.

** As the next step, enter ```sbcl``` in a terminal, or console -- the
command-line interface of your OS that is in your reach. **

You will start ```sbcl``` like this less frequent.  But we need its raw
interface for the start. You will see something like this:

![REPL](sbcl-raw-REPL.png)

Of course, you will see a blinking filled cursor after the asterisk. For now,
just enter your first *Lisp* expression there:

```
* (quit)
```

This will close this interface called "*REPL*" an acronym for
"Read-Eval-Print-Loop".

We need another service program now, *if it is not already installed*: *cURL*.
Again, on macOS you can use [MacPorts](https://ports.macports.org/port/curl/),
or [Homebrew](https://formulae.brew.sh/formula/curl#default).  On Linux, you use
the distribution's package manager, probably.  Windows users get the program
from [here](https://curl.se/windows/). **But don't install it right now. It
should be preinstalled in your system.** Only if the system tells you soon, that
it doesn't know how to **curl**, you have this information as backup.

**Now** we proceed with installing the quasi-standard *library manager* of *Common
Lisp*: [Quicklisp](https://www.quicklisp.org/beta/). The linked website
describes the necessary steps -- how they look like on macOS, Unix, and Linux.  It
should be nearly the same in a Windows console.

If you have troubles in getting the file ```quicklisp.lisp```, then just
download it directly and put it in your working directory.  The essential call
at the terminal prompt is:

```
$ sbcl --load quicklisp.lisp
```

which works, if the ```quicklisp.lisp``` file is in your working directory.

Here, you see how to start ```sbcl``` by immediately passing it a *Lisp*
program to execute.  That is what follows, as you can also see on the linked
website. 

You will be prompted to enter the expression to really install the *Quicklisp*
system.  So, at the asterisk of the REPL enter:

```
* (quicklisp-quickstart:install)
```

You will see a lot of messages.  They should just pass through so that you
finally see 

```==== quicklisp installed ====``` 

followed by a couple of hints. One hint is important at this stage.  Again, 
enter at the REPL prompt:

```
* (ql:add-to-init-file)
```

After this expression is effectively evaluated, ```sbcl``` always starts with
the library manager *Quicklisp*.  Now, you can again ```quit``` the REPL.

**Now, it is time to start a vanilla, unconfigured *Emacs*.**

You should find the starter icon in the regular way of your Desktop 
Environment. 

After *Emacs* is loaded, just use your first *Emacs* **keychord**!  Push
```Ctrl``` together with ```x```, leave your finger on ```Ctrl``` and push
```c```.  Probably *Emacs* will ask you whether you *really* want to quit.
However, yes, you want to.  

From now on, we will abbrevieat the ```Ctrl``` key with a capital ```C```.  And
if it shall be pushed together with another key, we combine them with a hyphen.
Thus the used keychord looks like this: ```C-x C-c```. 

After that, you can use your favourite way to open the Emacs
configuration *directory* ```.emacs.d```. You find it in your macOS/Linux/Unix
home directory, ```~/.emacs.d```.  On Windows, it probably will be found
correspondingly in ```C:\Users\<yourname>\.emacs.d```, or in
```C:/Users/<yourname>/AppData/Roaming/.emacs.d/```, according to [this
source](https://www.reddit.com/r/emacs/comments/1110smx/help_with_setting_up_emacs_on_windows/). (You
replace ```<yourname>``` with *your* name and without angle brackets, do you?)

**In this directory**,  you create a subdirectory *in* ```.emacs.d``` called
```slime-contribs```. 

## After preparatory work

Splendid, you came so far to save the ```init.el``` file I provide here in
```.emacs.d``` (**not** in ```.emacs.d/slime-contribs```).

Open the ```init.el``` with another editor than *Emacs*. Everything behind a
semicolon is a comment *for you*. 

**Windows** users: You probably now want to replace any slashes ```/``` in
pathnames with backslashes ```\```.  As for the rest: upcoming questions could
be answered by the comments. 

Now, you start *Emacs* again.

It *should* now install any needed *Emacs* package, switch to dark mode and
finish with the REPL provided by the *Superior Lisp Interaction Mode (Slime)*, a
buffer on top and a buffer with a filemanager on the left.  This
filemanager can be switchd of with the function key ```<F8>```.

You can watch the installation process in the single line at the bottom, called
the **mini buffer**. 

If everything works out, than your Emacs should look similar to this:

![Emacs](Emacs-start.png)
