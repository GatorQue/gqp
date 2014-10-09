# Filename: Options.cmake
# Description: Define the Freetype external 3rd party library options used in
#   the CMakeList.txt file.
# Modification Log:
# 2014-10-03 Initial version
#

# Freetype library options
set_option(FREETYPE_ENABLED TRUE BOOL "Build 'Freetype' 3rdparty/external libraries?")
# Freetype doesn't yet support shared libraries
set_option(FREETYPE_SHARED_LIBRARIES FALSE BOOL "Build 'Freetype' shared libraries?")
# Freetype comes with a pre-built API reference in HTML format
set_option(FREETYPE_BUILD_DOCS FALSE BOOL "Build 'Freetype' documentation?")
# Freetype examples are separate from the source code
set_option(FREETYPE_BUILD_EXAMPLES FALSE BOOL "Build 'Freetype' examples?")
set_option(FREETYPE_URL
  "http://download.savannah.gnu.org/releases-redirect/freetype/ft253.zip"
  STRING
  "URL for getting latest 'Freetype' version")

# Create a list of libraries provided by this 3rd party/external module
set(FREETYPE_LIBS freetype)
# Push the list to the parent scope for projects to reference
set(FREETYPE_LIBS ${FREETYPE_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(FREETYPE_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(FREETYPE_COMPONENTS ${FREETYPE_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
if(FREETYPE_SHARED_LIBRARIES)
  set(FREETYPE_DEFS -DFREETYPE_DYNAMIC)
else(FREETYPE_SHARED_LIBRARIES)
  set(FREETYPE_DEFS -DFREETYPE_STATIC)
endif(FREETYPE_SHARED_LIBRARIES)
# Push the list to the parent scope for projects to reference
set(FREETYPE_DEFS ${FREETYPE_DEFS} PARENT_SCOPE)

# Create a list of examples
set(FREETYPE_EXAMPLES)

# Create a list of external dependencies used by this external library
set(FREETYPE_DEPS)
# Push the list to the parent scope for projects to reference
set(FREETYPE_DEPS ${FREETYPE_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
if(WINDOWS)
  set(FREETYPE_LIB_DEPS)
else(WINDOWS)
  set(FREETYPE_LIB_DEPS)
endif(WINDOWS)
# Push the list to the parent scope for projects to reference
set(FREETYPE_LIB_DEPS ${FREETYPE_LIB_DEPS} PARENT_SCOPE)

# Add internal options if Freetype is enabled
if(FREETYPE_ENABLED)
  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES freetype)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/include)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(FREETYPE_DIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(FREETYPE_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(FREETYPE_BIN_DIR ${FREETYPE_BIN_DIR} PARENT_SCOPE)
endif(FREETYPE_ENABLED)

