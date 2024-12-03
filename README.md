Build Android-Nim-GLFM Applications
===

This is a build setup to more or less easily build Nim applications that run on android and use OpenGL for the interface via the GLFM system- also known as the 'gaming stack'.

It uses the normal Android build tools and works from the command line, but you can also use Android Studio if you want to.

Most little annoying things are automated away so it should be fairly straight forward to use.

Quick Instructions
---

Set up Nim and a C compiler, as well as a Java Development Kit that isn't too new, I use 17.

Connect an android device to your computer via USB and make sure you can reach it via adb (enable developer mode).

```sh
# prepare source
git clone https://github.com/capocasa/bang.git

# add GLFM source in the same directory
git clone https://github.com/brackeen/glfm.git

# install nim dependencies
nimble install opengl
nimble install https://github.com/capocasa/fglfm

# install android toolchain dependencies and build
app/gradlew -p app installDebug
```

You can skip the last step and set up an android studio project if you prefer, but you don't need it.

Quick Glossary
---

gradle - the android build tool
gradlew - the official gradle wrapper script that installs everything you need when you run it
NativeActivity - a java class that comes with android to have a standard way to run compiled code in a shared library (`.so` `.dylib` or `.dll`)
cmake - the preferred android build system for C code
glfm - a quick way to set up OpenGL
Nim - one language to rule them all, used to generate the C code

How It Works
---

When you run it, gradle:

- installs all android dependencies it needs
- Compiles the NativeActivity java class
- Runs the included cmake build script once arm, arm64, i386 and amd64
  - Calls the nim compiler to generate the C code
  - Calls the C compiler like normal
- installs the app on whatever device is connected via usb cable

The main Nim file needs to contain some GLFM boilerplate code.

Make it Yours
-------------

To use this as your own app, do the following

- Make up an app name like "Foo Bar", a technical app name without spaces like "foobar", and pick a domain, like "fuz.com"
- Go into `app/build.gradle` and replace both occurrences of `org.example.bang` with `com.fuz.foobar`. (It's java's way of having unique names in the language)
- Go into `app/CMakeLists.txt` and replace the project name `bang` with your technical app name `foobar`. You can change the nim source file name and nim source directory if you want to.
- Go into `app/src/main/AndroidManifest.xml` and change the `lib_name` tag from `bang` to your technical project name `foobar`
- Go into `app/src/main/res/values/strings.xml` and change the `app_name` value with our app name "Foo Bar". This is what users will see.
- Use some kind of android app icon generator, remove `app/src/main/res/midimap-*` directories and replace them with the output from the generator to have your own icon.

Sorry this is so all over the place. You could conceivably automate this but I think that would be too confusing and you have to do it once per app so it's okay. But do you think Google might have a bit of a complexity problem as an organization?

If you do all this, you will have a neatly branded android app.

You can build a testing .apk to show off like so

```sh
app/gradlew -p app assemble
```

You can also [get it into the app store](https://developer.android.com/build/building-cmdline#bundle_build_gradle).

There is a lot of nim configuration that needs to be done just right for android building, so the build script will steal control over the Nim command line from you and keep it all to itself. But you can still use `nim.cfg` or `foobar.nims` Nim configuration. If you really need to, you can find the line that says `${NIM_CMD} and carefully edit additional flags in before or after `${NIM_RELEASE_FLAGS}`.

Structuring your project
---

There are two good ways of structuring your project that I can think of.

The first is the one I use, have a nimble package with all of your main code that exports some startup and draw hooks. Then use this library to keep your android specific stuff out of the way and call into it.

The other option is to put this code into a directory `build/android` in your project, and point the nim source file in `CMakeLists.txt` somewhere into your source tree. Do this if you prefer a monolithic repository that you can build your app for any platform from.

Both approaches are fine. Personally I like keeping the build stuff out of my hair during app development effort but you will of course do whatever works for you.

Rationale
---

One reason a lot of us write web apps is because so many platforms have a browser you can write it once and have it work everywhere.

While this isn't true for native programs, thanks to the game ecosystem you can write a program once. While it might not immediately run everywhere, you can at least expect it to *build* for every ecosystem.

This isn't true at all for other ecosystems- operating system vendors like to make you do things their way. But they also can't afford to not have games. So if you accept to use game technology, you can control everything else. So game technology is the second most universal platform after browsers. Among gaming technology, if you don't need to push the limits, you can simply target OpenGL and you will have few issues. The idea here is to invest in a platform vendors can't afford to change.

For your trouble, you get a lot of power. Code that runs at native speed and you don't have to run it on a server. Local video encode anyone? New cryptocurrency? Messenging app with 3D stickers? The sky's the limit.

Interestingly, thanks to web apps, people tend not to expect an app to look and feel native anymore. So it's enough to design your UX to be more-or-less recognizable by mobile users. The unique feel can be part of your brand. And because you use gaming technology, people will just think you have yet another unique-looking app that's fast.

Ackknowledgements
---

I would like to thank *yglukhov* for demonstrating this is possible and *treeform* and *GordonBGood* for their prior work in this area from whom I have liberally lifted bits and pieces.

While we're add it, I'd also like to thank *Araq* for making Nim, *K&D* for C, *Wirth* for Pascal, and Alan Turing for the basics. ;)

FAQ
---

Q: Did you actually call this thing bang?

A: Yup. Couldn't resist :)


