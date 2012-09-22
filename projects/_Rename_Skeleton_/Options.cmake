# Filename: Options.cmake
# Description: Define the options used for this project.
# Modification Log:
# 2012-02-04 Initial version
# 2012-03-23 Simplify the options file for skeleton projects
#

# Project options
set_option(SKELETON_ENABLED FALSE BOOL "Build 'SKELETON' project?")
set_option(SKELETON_BUILD_DOCS TRUE BOOL "Build 'SKELETON' documentation?")
set_option(SKELETON_CONSOLE_ENABLED TRUE BOOL "Build 'SKELETON' as a console only executable?")

# Define the external libraries this project depends on
set(SKELETON_DEPS) #SFML THOR GQE ETC

