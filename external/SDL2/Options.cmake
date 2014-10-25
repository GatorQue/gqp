# Filename: Options.cmake
# Description: Define the SDL2 external 3rd party library options used in
#   the CMakeList.txt file.
# Modification Log:
# 2014-09-29 Initial version
#

# SDL2 library options
set_option(SDL2_ENABLED TRUE BOOL "Build 'SDL2' 3rdparty/external libraries?")
set_option(SDL2_SHARED_LIBRARIES TRUE BOOL "Build 'SDL2' shared libraries?")
# SDL2 documentation is online only
set_option(SDL2_BUILD_DOCS FALSE BOOL "Build 'SDL2' documentation?")
set_option(SDL2_BUILD_EXAMPLES FALSE BOOL "Build 'SDL2' examples?")

# Determine which URL to use to obtain the SDL2 source files
set_option(SDL2_URL
  "https://www.libsdl.org/release/SDL2-2.0.3.zip"
  STRING
  "URL for getting latest 'SDL2' version")

# Create a list of examples
set(SDL2_EXAMPLES)

# Create a list of libraries provided by this 3rd party/external module
set(SDL2_LIBS SDL2 SDL2main)
# Push the list to the parent scope for projects to reference
set(SDL2_LIBS ${SDL2_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(SDL2_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(SDL2_COMPONENTS ${SDL2_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
set(SDL2_DEFS)
# Push the list to the parent scope for projects to reference
set(SDL2_DEFS ${SDL2_DEFS} PARENT_SCOPE)

# Create a list of external dependencies used by this external library
set(SDL2_DEPS)
# Push the list to the parent scope for projects to reference
set(SDL2_DEPS ${SDL2_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(SDL2_LIB_DEPS)
# Push the list to the parent scope for projects to reference
set(SDL2_LIB_DEPS ${SDL2_LIB_DEPS} PARENT_SCOPE)

# Add internal options if ZLIB is enabled
if(SDL2_ENABLED)
  # Define the libraries produced by this external module

  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES SDL2 SDL2main)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/include
    ${PROJECT_BINARY_DIR}/${EXTERNAL_OPTION_DIR}/clone/include)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(SDL2DIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(SDL2_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(SDL2_BIN_DIR ${SDL2_BIN_DIR} PARENT_SCOPE)
endif(SDL2_ENABLED)

