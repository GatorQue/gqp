# Filename: Options.cmake
# Description: Define the options used for this project.
# Modification Log:
# 2012-02-04 Initial version
#

# Project options
set_option(EXAMPLE_ENABLED TRUE BOOL "Build 'Example' project?")
set_option(EXAMPLE_BUILD_DOCS TRUE BOOL "Build 'Example' documentation?")
set_option(EXAMPLE_CONSOLE_ENABLED TRUE BOOL "Build 'Example' as a console only executable?")

# Define the external libraries this project depends on
set(EXAMPLE_DEPS GQE)

