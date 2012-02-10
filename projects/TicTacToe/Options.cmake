# Filename: Options.cmake
# Description: Define the options used for this project.
# Modification Log:
# 2012-02-04 Initial version
#

# Project options
set_option(TICTACTOE_ENABLED TRUE BOOL "Build 'TICTACTOE' project?")
set_option(TICTACTOE_BUILD_DOCS TRUE BOOL "Build 'TICTACTOE' documentation?")

# Define the 3rdparty/external libraries this project depends on
set(TICTACTOE_3RDPARTY_DEPENDS GQE SFML)

# Define the package components for each 3rdparty/external library
if(WINDOWS)
  set(TICTACTOE_3RDPARTY_COMPONENTS
    GQE core
    SFML audio graphics window network system main)
else(WINDOWS)
  set(TICTACTOE_3RDPARTY_COMPONENTS
    GQE core
    SFML audio graphics window network system)
endif(WINDOWS)

# Define custom CMake configuration arguments for this project (if desired)
#set(TICTACTOE_CONFIG_ARGS "
#  -DCUSTOM_FLAG:BOOL=TRUE
#  -DCUSTOM_DIR:PATH=\"${PATH_VARIABLE_OR_VALUE}\"")

# Define a single custom build target for this project (if desired)
#set(TICTACTOE_BUILD_ARGS --target MyCustomTarget)

# If this project is enabled, add it to the subproject dependency list
if(TICTACTOE_ENABLED)
  # Add this subproject to the list of projects to be built
  set(SUBPROJECT_DEPENDS ${SUBPROJECT_DEPENDS} TICTACTOE)
endif(TICTACTOE_ENABLED)

