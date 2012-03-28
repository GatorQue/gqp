# Filename: Options.cmake
# Description: Define the Thor external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# Thor library options
set_option(THOR_ENABLED TRUE BOOL "Build 'Thor' 3rdparty/external libraries?")
# THOR_SHARED_LIBRARIES is fixed to SFML_SHARED_LIBRARIES
#set_option(THOR_SHARED_LIBRARIES TRUE BOOL "Build 'Thor' shared libraries?")
set_option(THOR_REVISION_TAG "" STRING "Which 'Thor' revision/tag to use?")
set_option(THOR_BUILD_DOCS FALSE BOOL "Build 'Thor' documentation?")
set_option(THOR_BUILD_EXAMPLES FALSE BOOL "Build 'Thor' examples?")
set_option(THOR_URL
  "http://www.bromeon.ch/svn/thor/trunk"
  STRING
  "SVN URL to obtain latest 'Thor' version")

# Create a list of libraries provided by this 3rd party/external module
set(THOR_LIBS thor)
# Push the list to the parent scope for projects to reference
set(THOR_LIBS ${THOR_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(THOR_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(THOR_COMPONENTS ${THOR_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
if(THOR_SHARED_LIBRARIES)
  set(THOR_DEFS -DTHOR_DYNAMIC)
else(THOR_SHARED_LIBRARIES)
  set(THOR_DEFS -DTHOR_STATIC)
endif(THOR_SHARED_LIBRARIES)
# Push the list to the parent scope for projects to reference
set(THOR_DEFS ${THOR_DEFS} PARENT_SCOPE)

# Create a list of examples
set(THOR_EXAMPLES
  Action Animation Multimedia Particles Resources Time Triangulation UserEvents)

# Create a list of external dependencies used by this external library
set(THOR_DEPS SFML)
# Push the list to the parent scope for projects to reference
set(THOR_DEPS ${THOR_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
if(WINDOWS)
  set(THOR_LIB_DEPS
    SFML sfml-audio sfml-graphics sfml-window sfml-network sfml-system sfml-main)
else(WINDOWS)
  set(THOR_LIB_DEPS
    SFML sfml-audio sfml-graphics sfml-window sfml-network sfml-system)
endif(WINDOWS)
# Push the list to the parent scope for projects to reference
set(THOR_LIB_DEPS ${THOR_LIB_DEPS} PARENT_SCOPE)

# Add internal options if THOR is enabled
if(THOR_ENABLED)
  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES thor)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/include)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(THORDIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(THOR_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(THOR_BIN_DIR ${THOR_BIN_DIR} PARENT_SCOPE)
endif(THOR_ENABLED)

