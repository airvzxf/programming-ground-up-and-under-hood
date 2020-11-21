GUI Programming
===============

Introduction to GUI Programming {.unnumbered}
===============================

The purpose of this appendix is not to teach you how to do Graphical
User Interfaces. It is simply meant to show how writing graphical
applications is the same as writing other applications, just using an
additional library to handle the graphical parts. As a programmer you
need to get used to learning new libraries. Most of your time will be
spent passing data from one library to another.

The GNOME Libraries {.unnumbered}
===================

The GNOMEGNOME projects is one of several projects to provide a complete
desktop to Linux users. The GNOME project includes a panel to hold
application launchers and mini-applications called applets, several
standard applications to do things such as file management, session
management, and configuration, and an API for creating applications
which fit in with the way the rest of the system works.

One thing to notice about the GNOME libraries is that they constantly
create and give you pointers to large data structures, but you never
need to know how they are laid out in memory. All manipulation of the
GUI data structures are done entirely through function calls. This is a
characteristic of good library design. Libraries change from version to
version, and so does the data that each data structure holds. If you had
to access and manipulate that data yourself, then when the library is
updated you would have to modify your programs to work with the new
library, or at least recompile them. When you access the data through
functions, the functions take care of knowing where in the structure
each piece of data is. The pointers you receive from the library are
*opaque* - you don\'t need to know specifically what the structure they
are pointing to looks like, you only need to know the functions that
will properly manipulate it. When designing libraries, even for use
within only one program, this is a good practice to keep in mind.

This chapter will not go into details about how GNOME works. If you
would like to know more, visit the GNOME developer web site at
http://developer.gnome.org/. This site contains tutorials, mailing
lists, API documentation, and everything else you need to start
programming in the GNOME environment.

A Simple GNOME Program in Several Languages {.unnumbered}
===========================================

This program will simply show a Window that has a button to quit the
application. When that button is clicked it will ask you if you are
sure, and if you click yes it will close the application. To run this
program, type in the following as `gnome-example.s`:

    GNOME-EXAMPLE-S

To build this application, execute the following commands:

    as gnome-example.s -o gnome-example.o
    gcc gnome-example.o `gnome-config --libs gnomeui` \
        -o gnome-example

Then type in `./gnome-example` to run it.

This program, like most GUIGUI programs, makes heavy use of passing
pointers to functions as parameters. In this program you create widgets
with the GNOME functions and then you set up functions to be called when
certain events happen. These functions are called *callback* functions.
All of the event processing is handled by the function `gtk_main`, so
you don\'t have to worry about how the events are being processed. All
you have to do is have callbacks set up to wait for them.

Here is a short description of all of the GNOME functions that were used
in this program:

gnome_init

:   Takes the command-line arguments, argument count, application id,
    and application version and initializes the GNOME libraries.

gnome_app_new

:   Creates a new application window, and returns a pointer to it. Takes
    the application id and the window title as arguments.

gtk_button_new_with_label

:   Creates a new button and returns a pointer to it. Takes one
    argument - the text that is in the button.

gnome_app_set_contents

:   This takes a pointer to the gnome application window and whatever
    widget you want (a button in this case) and makes the widget be the
    contents of the application window

gtk_widget_show

:   This must be called on every widget created (application window,
    buttons, text entry boxes, etc) in order for them to be visible.
    However, in order for a given widget to be visible, all of its
    parents must be visible as well.

gtk_signal_connect

:   This is the function that connects widgets and their signal handling
    callback functions. This function takes the widget pointer, the name
    of the signal, the callback function, and an extra data pointer.
    After this function is called, any time the given event is
    triggered, the callback will be called with the widget that produced
    the signal and the extra data pointer. In this application, we
    don\'t use the extra data pointer, so we just set it to NULL, which
    is 0.

gtk_main

:   This function causes GNOME to enter into its main loop. To make
    application programming easier, GNOME handles the main loop of the
    program for us. GNOME will check for events and call the appropriate
    callback functions when they occur. This function will continue to
    process events until `gtk_main_quit` is called by a signal handler.

gtk_main_quit

:   This function causes GNOME to exit its main loop at the earliest
    opportunity.

gnome_message_box_new

:   This function creates a dialog window containing a question and
    response buttons. It takes as parameters the message to display, the
    type of message it is (warning, question, etc), and a list of
    buttons to display. The final parameter should be NULL to indicate
    that there are no more buttons to display.

gtk_window_set_modal

:   This function makes the given window a modal window. In GUI
    programming, a modal window is one that prevents event processing in
    other windows until that window is closed. This is often used with
    Dialog windows.

gnome_dialog_run_and_close

:   This function takes a dialog pointer (the pointer returned by
    `gnome_message_box_new` can be used here) and will set up all of the
    appropriate signal handlers so that it will run until a button is
    pressed. At that time it will close the dialog and return to you
    which button was pressed. The button number refers to the order in
    which the buttons were set up in `gnome_message_box_new`.

The following is the same program written in the C language. Type it in
as `gnome-example-c.c`:

    GNOME-EXAMPLE-C-C

To compile it, type

    gcc gnome-example-c.c `gnome-config --cflags \
        --libs gnomeui` -o gnome-example-c

Run it by typing `./gnome-example-c`.

Finally, we have a version in Python. Type it in as gnome-example.py:

    GNOME-EXAMPLE-PY

To run it type `python gnome-example.py`.

GUI Builders {.unnumbered}
============

In the previous example, you have created the user-interface for the
application by calling the create functions for each widget and placing
it where you wanted it. However, this can be quite burdensome for more
complex applications. Many programming environments, including GNOME,
have programs called GUI builders that can be used to automatically
create your GUI for you. You just have to write the code for the signal
handlers and for initializing your program. The main GUI builderGUI
builder for GNOME applications is called GLADE. GLADE ships with most
Linux distributions.

There are GUI builders for most programming environments. Borland has a
range of tools that will build GUIs quickly and easily on Linux and
Win32Win32 systems. The KDE environment has a tool called QT DesignerQT
Designer which helps you automatically develop the GUI for their system.

There is a broad range of choices for developing graphical applications,
but hopefully this appendix gave you a taste of what GUI programming is
like.
