# GatorQue Projects #
# Mission #
To create, as a community, the easiest CMake build environment for building personal projects that depend on external libraries like Box2D, Lua, TinyXML, SFML, GQE, and/or THOR.

---

## News/Welcome! ##
Apr  2, 2012
I published a new version which adds Lua scripting language support as an external module for GQP.  I am working on adding some new features to GQE right now and some of these changes might drive GQP to pick up a few updates. But for now GQP appears to be fairly stable for the moment.

Jul 28, 2012
I published a small update (v0.12.1) to fix some Linux compiling related issues discovered by the GQE/GQP team. The GQE/GQP team has entered their first game into the Liberated Pixel Cup (LPC) competition at OpenGameArt?.org. The name of the game is Traps and Treasures (look for gqp-tnt Google Code project for the source) and the competition ends on Tuesday, July 31st. Wish us luck on winning some of the prize money.

Jul 7, 2012
I published a new version of GQP that fixes many issues with finding prebuilt 3rd party libraries. I also published prebuild 3rd party libraries for VS2010 both static and shared library versions. Static libraries will likely give you the least amount of trouble.

Jul 6, 2012
At the suggestion of a friend of mine I will be working on making GQP download most of the tools listed below if they are not found on your computer. This will make GQP adoption easier.  I have also posted (or am in the process of posting today) tutorials on using GQP for Visual Studio, Code::Blocks, MinGW, and Linux. If someone has access to a Macintosh computer and could contribute an XCode tutorial I would really appreciate it.

Jun 16, 2012
I just pushed a minor change that fixes an error copying the zlib1.dll file when using the zlib external library module.

May 25, 2012
I just added [TinyXML](http://www.grinninglizard.com/tinyxml/) support and some minor changes to fix GQE compatibility.

Mar 30, 2012
I just added [Box2D](http://box2d.org/) support and some changes to support [GQE](http://code.google.com/p/gqe/) updates (including the new SpaceDots example program).

Feb 11, 2012
This project will make using external libraries in your project easier. To build your project against libraries like [SFML](http://www.sfml-dev.org/), [GQE](http://code.google.com/p/gqe/), [Thor](http://www.bromeon.ch/thor), and/or [Box2D](http://box2d.org/) (your library not listed? add an issue to have it added) you just need to specify which of these libraries you want and GQP will handle all the details to make it happen.

---

## Getting Started ##
  1. The first thing you will need to use GQP are a few programs.
    * [Cmake](http://www.cmake.org/cmake/resources/software.html) - the build tool used by GQP
    * [Subversion](http://tortoisesvn.net/downloads.html) - a Version Control tool used by some 3rd party/external libraries like Thor
    * [Git](http://git-scm.com/download) - a Version Control tool used by some 3rd party/external libraries like SFML
    * [Hg/Mercurial](http://tortoisehg.bitbucket.org/download/index.html) - a Version Control tool used by some 3rd part/external libraries like GQE
    * [Doxygen](http://www.stack.nl/~dimitri/doxygen/download.html#latestsrc) - a tool used to generate documentation from the original source code
  1. The second thing you will need is a compiler, pick your favorite one from this list:
    * [Visual Studio Express](http://www.microsoft.com/express) - Windows platform only, made by Microsoft
    * [CodeBlocks with MinGW](http://www.codeblocks.org/downloads/26) - Linux/Windows/Mac platforms, open source
    * [Eclipse](http://www.eclipse.org/downloads/) - Linux/Windows/Mac/Unix platforms, open source and very good but don't forget to download [MinGW](http://sourceforge.net/projects/mingw/files/) if you use it on Windows
    * Both [CodeBlocks](http://www.codeblocks.org/downloads/26) and [Eclipse](http://www.eclipse.org/downloads/) can use the GCC compiler for windows known as [MinGW](http://sourceforge.net/projects/mingw/files/).
  1. The last thing you will need is the latest copy of GQP and to follow the tutorials for your particular platform and compiler choice (see new tutorial links to your left).

---

## Features/Goals ##
  * Download external libraries straight from their repositories
  * Configure and build external libraries along with your projects
  * Easily make external libraries available for your projects
  * Easily find and compile source code for your projects
  * Easily unit test your projects (coming soon)
  * Easily package your projects into installers for distribution to friends (coming soon)
  * Well documented (getting better)
  * Easily Extendable (documentation coming soon)

---

## Roadmap ##
The roadmap https://trello.com/gqp is presented using a collaborative tool and free service called Trello (made by my hero Joel Spolsky). Trello allows you to visually track my development progress and participate by leaving comments, checklists, and other things on the development board.