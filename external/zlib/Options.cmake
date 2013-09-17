# Filename: Options.cmake
# Description: Define the zlib external 3rd party library options used in
#   the CMakeList.txt file.
# Modification Log:
# 2012-05-25 Initial version
# 2012-05-25 Allow shared libraries for non-Windows systems and fixed include dir
#

# ZLIB library options
set_option(ZLIB_ENABLED TRUE BOOL "Build 'zlib' 3rdparty/external libraries?")
set_option(ZLIB_SHARED_LIBRARIES TRUE BOOL "Build 'zlib' shared libraries?")
set_option(ZLIB_BUILD_DOCS FALSE BOOL "Build 'zlib' documentation?")
set_option(ZLIB_BUILD_EXAMPLES FALSE BOOL "Build 'zlib' examples?")

# Determine which URL to use to obtain the ZLIB source files
set_option(ZLIB_URL
  "http://zlib.net/zlib-1.2.8.tar.gz"
  STRING
  "URL for getting latest 'zlib' version")

# Create a list of examples
set(ZLIB_EXAMPLES example-zlib minigzip example64-zlib minigzip64)

# Create a list of libraries provided by this 3rd party/external module
set(ZLIB_LIBS zlib)
# Push the list to the parent scope for projects to reference
set(ZLIB_LIBS ${ZLIB_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(ZLIB_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(ZLIB_COMPONENTS ${ZLIB_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
set(ZLIB_DEFS)
# Push the list to the parent scope for projects to reference
set(ZLIB_DEFS ${ZLIB_DEFS} PARENT_SCOPE)

# Create a list of external dependencies used by this external library
set(ZLIB_DEPS)
# Push the list to the parent scope for projects to reference
set(ZLIB_DEPS ${ZLIB_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(ZLIB_LIB_DEPS)
# Push the list to the parent scope for projects to reference
set(ZLIB_LIB_DEPS ${ZLIB_LIB_DEPS} PARENT_SCOPE)

# Add internal options if ZLIB is enabled
if(ZLIB_ENABLED)
  # Define the libraries produced by this external module

  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES zlib)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}
    ${PROJECT_BINARY_DIR}/${EXTERNAL_OPTION_DIR}/clone)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(ZLIBDIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(ZLIB_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(ZLIB_BIN_DIR ${ZLIB_BIN_DIR} PARENT_SCOPE)
endif(ZLIB_ENABLED)

