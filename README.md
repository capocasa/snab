SDL2-Nim-Android Build
===

This is a build setup to more or less easily build Nim applications that run on android and use the SDL2 framework.

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
SDLActivity- a java class that comes with SDL for android to have a standard way to run compiled code in a shared library (`.so` `.dylib` or `.dll`)
cmake - the preferred android build system for C code
SDL2 - a framework to have keyboard, screen, mouse, touch and sound across phones and computers so you only have to write most of the code once
Nim - one language to rule them all, used to generate the C code

How It Works
---

When you run it, gradle:

- installs all android dependencies it needs
- Compiles the SDL java classes
- Runs the included cmake build script once arm, arm64, i386 and amd64
  - Calls the nim compiler to generate the C code
  - Calls the C compiler like normal
- installs the app on whatever device is connected via usb cable

The main Nim file needs to contain some SDL boilerplate code.

Make it Yours
-------------

To use this as your own app, do the following

- Make up an app name like "Foo Bar", a technical app name without spaces like "foobar", and pick a domain, like "fuz.com"
- Go into `app/build.gradle` and replace both occurrences of `org.example.bang` with `com.fuz.foobar`. (It's java's way of having unique names in the language)
- Go into `app/CMakeLists.txt` and replace the project name `bang` with your technical app name `foobar`. You can change the nim source file name and nim source directory if you want to.
- Go into `app/src/main/AndroidManifest.xml` and change the `lib_name` tag from `bang` to your technical project name `foobar`
- Go into `app/src/main/res/values/strings.xml` and change the `app_name` value with our app name "Foo Bar". This is what users will see.
- Go into `app/src/java` and change the org/example/snab directories to com/fuz. Rename Snab.java to `Foobar.java`. Replace org.example.snap with com.fuz and Snab with foobar in the java file. value with our app name "Foo Bar". This makes sure your technical app name is unique within the java code on the device and saves trouble.
- Use some kind of android app icon generator, remove `app/src/main/res/midimap-*` directories and replace them with the output from the generator to have your own icon.

Sorry this is so all over the place. You could conceivably automate this but I think that would be too confusing and you have to do it once per app so it's okay. But do you think Google might have a bit of a complexity problem as an organization?

If you do all this, you will have a neatly branded android app.

You can build a testing .apk to show off like so

```sh
app/gradlew -p app assemble
```

You can also [get it into the app store](https://developer.android.com/build/building-cmdline#bundle_build_gradle).

There is a lot of nim configuration that needs to be done just right for android building, so the build script will steal control over the Nim command line from you and keep it all to itself. But you can still use `nim.cfg` or `foobar.nims` Nim configuration. If you really need to, you can find the line that says `${NIM_CMD} and carefully edit additional flags in before or after `${NIM_RELEASE_FLAGS}`.


Acknowledgements
---

Many thanks to *yglukhov*, *treeform* and *GordonBGood*. And myself, for the [GLFM version](https://github.com/capocasa/bang) version of this :)

