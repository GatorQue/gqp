# Filename: Options.cmake
# Description: Define the SFML external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# SFML library options
set_option(SFML_ENABLED TRUE BOOL "Build 'SFML' 3rdparty/external libraries?")
set_option(SFML_SHARED_LIBRARIES TRUE BOOL "Build 'SFML' shared libraries?")
set_option(SFML_USE_LATEST TRUE BOOL "Use 'SFML' version 2.x from GIT repository?")
set_option(SFML_REVISION_TAG "" STRING "Which 'SFML' revision/tag to use?")
set_option(SFML_BUILD_DOCS FALSE BOOL "Build 'SFML' documentation?")
set_option(SFML_BUILD_EXAMPLES FALSE BOOL "Build 'SFML' examples?")

# Determine which URL to use to obtain the SFML source files
if(SFML_USE_LATEST)
  set_option(SFML_URL
    "https://github.com/LaurentGomila/SFML.git"
    STRING
    "Git URL for getting latest 'SFML' version")

  # Create a list of examples
  set(SFML_EXAMPLES
    ftp opengl pong shader sockets sound sound-capture voip win32 window)
else(SFML_USE_LATEST)
  set_option(SFML_URL
    "http://gqe.googlecode.com/files/SFML-1.6.4-cmake.zip"
    STRING
    "URL for getting older 'SFML' version")

  # Create a list of examples
  set(SFML_EXAMPLES
    ftp opengl pong shader sockets sound sound-capture voip win32 window)
endif(SFML_USE_LATEST)

# Create a list of libraries provided by this 3rd party/external module
set(SFML_LIBS
  sfml-audio sfml-graphics sfml-window sfml-network sfml-system sfml-main)
# Push the list to the parent scope for projects to reference
set(SFML_LIBS ${SFML_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(SFML_COMPONENTS AUDIO GRAPHICS WINDOW NETWORK SYSTEM MAIN)
# Push this list to the parent scope for projects to reference
set(SFML_COMPONENTS ${SFML_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
if(SFML_SHARED_LIBRARIES)
  set(SFML_DEFS -DSFML_DYNAMIC)
else(SFML_SHARED_LIBRARIES)
  set(SFML_DEFS -DSFML_STATIC)
endif(SFML_SHARED_LIBRARIES)
# Push the list to the parent scope for projects to reference
set(SFML_DEFS ${SFML_DEFS} PARENT_SCOPE)

# Create a list of external dependencies used by this external library
set(SFML_DEPS)
# Push the list to the parent scope for projects to reference
set(SFML_DEPS ${SFML_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(SFML_LIB_DEPS)
# Push the list to the parent scope for projects to reference
set(SFML_LIB_DEPS ${SFML_LIB_DEPS} PARENT_SCOPE)

# Add internal options if SFML is enabled
if(SFML_ENABLED)
  # Define the libraries produced by this external module
  set(FIND_AUDIO_LIBRARY    sfml-audio)
  set(FIND_GRAPHICS_LIBRARY sfml-graphics)
  set(FIND_WINDOW_LIBRARY   sfml-window)
  set(FIND_NETWORK_LIBRARY  sfml-network)
  set(FINDL_SYSTEM_LIBRARY   sfml-system)
  set(FIND_MAIN_LIBRARY     sfml-main)

  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES
    ${FIND_AUDIO_LIBRARY}
    ${FIND_GRAPHICS_LIBRARY}
    ${FIND_WINDOW_LIBRARY}
    ${FIND_NETWORK_LIBRARY}
    ${FIND_SYSTEM_LIBRARY}
    ${FIND_MAIN_LIBRARY})

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/include)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(SFMLDIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(SFML_BIN_DIR
    ${EXTERNAL_BIN_DIR}
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/extlibs/bin/${TARGET_ARCH_TYPE})
  # Push the list to the parent scope for projects to reference
  set(SFML_BIN_DIR ${SFML_BIN_DIR} PARENT_SCOPE)
endif(SFML_ENABLED)

