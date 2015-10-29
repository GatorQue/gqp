# Introduction #
GQP was specifically designed to make Debugging in Code::Blocks easier. When you debug your project, it is often helpful to be able to set breakpoints in the source code of your 3rd party libraries so you can figure out what is going wrong. To do this, the source code must be available for Code::Blocks to provide this information. GQP produces a Code::Blocks project file that has all the source code for the 3rd party libraries your project references so you can add these breakpoints. Setting up GQP is not very hard and will be detailed below.

# Details #
Step 0:
Download and install CMake, HG, SVN, Git, Doxygen, and a compiler before downloading GQP. Extract GQP somewhere on your hard drive (e.g. C:\GQP).

Step 1:
GQP supports several 3rd party libraries natively. Each 3rd party library has its own Options.cmake file (see GQP/external/SFML/Options.cmake as an example) that can be modified to meet your projects specific needs. Some of the options that can be modified include:
  * Enabling or Disabling the 3rd party module from being used by GQP
  * Using v2.0 RC (default) or v1.6 version of [SFML](http://www.sfml-dev.org/)
  * Building the Example programs that come with each 3rd party module
  * Building the Documentation for each 3rd party module (often using Doxygen)
  * Using Shared or Static libraries when building each 3rd party module
  * Specifying a specific revision tag to use when downloading each 3rd party module (defaults to Tip/Master)

Simply edit the Options.cmake file in the corresponding 3rd party library folder to adjust these settings.

Step 2:
Create a game project folder in GQP or modify the Example project folder provided. For example, you might like to create a Galaga space shoot-em-up game. To accomplish this you navigate to the GQP/projects folder and copy either the "_Rename\_Skeleton_" folder as "Galaga" or the Example folder as "Galaga". Then navigate and edit the Galaga/Options.cmake file and change every "SKELETON_" or "EXAMPLE_" to "GALAGA_" that you see in this file (there should only be two or three of them). The directory name you choose should match this name since that is how GQP matches project options to the directory they came from during the CMake processing. You should also modify the GALAGA\_DEPS option in this file and add, in capital letters, the directory names of each 3rd party library you wish to use for your GALAGA program so that CMake will link these 3rd party libraries against your project during the Linker phase of compiling. Once this has been done you are ready to proceed to the next step._

Step 3:
CMake works best if you build your code "out of source".  This just means that you should create and navigate to a build directory before running CMake.  I usually create C:\GQP\build for Code::Blocks. Next open a command prompt (Start->Run->cmd OR Start->Accessories->Command Prompt). Navigate to this directory (cd C:\GQP\build) and type the following.

C:\GQP\build\cmake -G "CodeBlocks - MinGW Makefiles" ..

This will cause CMake to begin processing each CMakeList.txt files found throughout GQP which will result in a Code::Blocks project file being created. During the processing of each external (3rd party) directory CMake will discover that each 3rd party library hasn't been downloaded yet and will download each 3rd party library to the C:\GQP folder (e.g. C:\GQP\SFML, C:\GQP\GQE, etc.) directly from their GIT/HG/SVN sources on the Internet. Once downloaded it will parse each of their CMake files and add them to our master Code::Blocks project file. GQP will only download the 3rd party library if their folder doesn't exist in the GQP folder, so if you want to force GQP to update the SFML external library just delete the C:\GQP\SFML folder and rerun the cmake step above.
Also, if you add a new "project" folder you can simply rerun the cmake step above to have the new project added to the master Code::Blocks project file. If everything goes well you should see "-- Build files have been written to: C:/GQP/build" indicating CMake completed successfully.

Step 4:
Open the newly created Code::Blocks project file (C:\GQP\build\TopLevel.cbd) and notice how GQP has created a tree of Source and Header files including all 3rd party libraries and a subtree folder called projects for each of your project you have listed in GQP. To make one of your project files the default project find the project name in the Build target pull down menu on the toolbar at the top. This will tell Code::Blocks which executable to run when you push the "Green Arrow" (or press Ctrl-F10) on the tool bar. Code::Blocks defaults to running all programs from the build directory, this will prevent your projects from finding their resource files. To fix this you need to select Project->Properties from the tool bar menu and then click on the Build targets tab in the Properties window. Locate your projects Build target from the list on the left and change the Execution working dir to "projects\<Project Name>" instead.

Step 5:
Now you are ready to add some files to your project. If you already have files listed you can proceed with step 6 or do one of the following to add files to your project.
  * Add files to your project by copying files to C:\GQP\projects\<Project Name>\src.
  * Right click on either Header Files or Source Files and select Add->New Item and change the directory shown to C:\GQP\projects\<Project Name>\src and add the name of the file you wish to add and push the Add button.
  * Add or modify the images, sounds, fonts, music, configuration files, etc. in the C:\GQP\projects\<Project Name>\resources folder.

Step 6:
There are several ways to compile your code in Code::Blocks. You can build the "all" target from the Build targets menu. You can select a specific target and press F9, or you can push the Build or Build and Run icons on the tool bar. Either way you do it, compile your code, run your code, debug your code, and enjoy coding your projects into existence. After each successful compile, GQP will cause Code::Blocks to copy your projects resources folder (C:\GQP\projects\<Project Name>\resources) to the build directory it created for your project (C:\GQP\build\projects\<Project Name>\resources). It will also copy the DLL files (if your using shared libraries, which is the default option) from your 3rd party libraries to the build directory it created for your project (C:\GQP\build\projects\<Project Name>). If you make changes to your resource files or 3rd party library source code you can force the resource files or 3rd party DLL files to be recopied to your build directory by forcing Code::Blocks to recompile your project. The easiest way to do this is to modify one of your projects source files and save it again and repeat the build.