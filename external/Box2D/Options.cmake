# Filename: Options.cmake
# Description: Define the Thor external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# Thor library options
set_option(BOX2D_ENABLED TRUE BOOL "Build 'Box2D' 3rdparty/external libraries?")
set_option(BOX2D_SHARED_LIBRARIES FALSE BOOL "Build 'Box2D' shared libraries?")
set_option(BOX2D_REVISION_TAG "" STRING "Which 'Box2D' revision/tag to use?")
set_option(BOX2D_BUILD_DOCS FALSE BOOL "Build 'Box2D' documentation?")
set_option(BOX2D_BUILD_EXAMPLES FALSE BOOL "Build 'Box2D' examples?")
set_option(BOX2D_URL
  "http://box2d.googlecode.com/svn/trunk"
  STRING
  "SVN URL to obtain latest 'Box2D' version")

# Examples depend on Static library version of Box2D
if(BOX2D_BUILD_EXAMPLES)
  set(BOX2D_BUILD_STATIC TRUE CACHE BOOL "Build static libraries" FORCE)
  set(BOX2D_LIBS Box2D)
else(BOX2D_BUILD_EXAMPLES)
  set(BOX2D_BUILD_STATIC FALSE CACHE BOOL "Build static libraries" FORCE)
endif(BOX2D_BUILD_EXAMPLES)

# Create a list of libraries provided by this 3rd party/external module
if(BOX2D_SHARED_LIBRARIES)
  set(BOX2D_LIBS ${BOX2D_LIBS} Box2D_shared)
else(BOX2D_SHARED_LIBRARIES)
  set(BOX2D_BUILD_STATIC TRUE CACHE BOOL "Build static libraries" FORCE)
  set(BOX2D_LIBS Box2D)
endif(BOX2D_SHARED_LIBRARIES)
# Push the list to the parent scope for projects to reference
set(BOX2D_LIBS ${BOX2D_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(BOX2D_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(BOX2D_COMPONENTS ${BOX2D_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
#if(BOX2D_SHARED_LIBRARIES)
#  set(BOX2D_DEFS -DBOX2D_DYNAMIC)
#else(BOX2D_SHARED_LIBRARIES)
#  set(BOX2D_DEFS -DBOX2D_STATIC)
#endif(BOX2D_SHARED_LIBRARIES)
# Push the list to the parent scope for projects to reference
#set(BOX2D_DEFS ${BOX2D_DEFS} PARENT_SCOPE)

# Create a list of examples
set(BOX2D_EXAMPLES freeglut_static glui HelloWorld Testbed)

# Create a list of external dependencies used by this external library
set(BOX2D_DEPS)
# Push the list to the parent scope for projects to reference
set(BOX2D_DEPS ${BOX2D_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(BOX2D_LIB_DEPS)
# Push the list to the parent scope for projects to reference
set(BOX2D_LIB_DEPS ${BOX2D_LIB_DEPS} PARENT_SCOPE)

# Add internal options if BOX2D is enabled
if(BOX2D_ENABLED)
  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES Box2D)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/Box2D)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(BOX2DDIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(BOX2D_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(BOX2D_BIN_DIR ${BOX2D_BIN_DIR} PARENT_SCOPE)
endif(BOX2D_ENABLED)

