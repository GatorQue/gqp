# Filename: Options.cmake
# Description: Define the TinyXML external 3rd party library options used in
#   the CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# TINYXML library options
set_option(TINYXML_ENABLED TRUE BOOL "Build 'TinyXML' 3rdparty/external libraries?")
# TINYXML only supports Static library builds
set_option(TINYXML_SHARED_LIBRARIES FALSE BOOL "Build 'TinyXML' shared libraries?")
# TINYXML supports both STL and non-STL builds
set_option(TINYXML_USE_STL TRUE BOOL "Enable STL use for 'TinyXML' library?")
set_option(TINYXML_REVISION_TAG "" STRING "Which 'TinyXML' revision/tag to use?")
set_option(TINYXML_BUILD_DOCS TRUE BOOL "Build 'TinyXML' documentation?")
# TINYXML doesn't provide examples
set_option(TINYXML_BUILD_EXAMPLES FALSE BOOL "Build 'TinyXML' examples?")

# Determine which URL to use to obtain the TINYXML source files
set_option(TINYXML_URL
  "http://sourceforge.net/projects/tinyxml/files/latest/download"
  STRING
  "URL for getting latest 'TinyXML' version")

# Create a list of examples
set(TINYXML_EXAMPLES)

# Create a list of libraries provided by this 3rd party/external module
set(TINYXML_LIBS tinyxml)
# Push the list to the parent scope for projects to reference
set(TINYXML_LIBS ${TINYXML_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(TINYXML_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(TINYXML_COMPONENTS ${TINYXML_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
if(TINYXML_USE_STL)
  set(TINYXML_DEFS -DTIXML_USE_STL)
endif(TINYXML_USE_STL)
# Push the list to the parent scope for projects to reference
set(TINYXML_DEFS ${TINYXML_DEFS} PARENT_SCOPE)

# Create a list of external dependencies used by this external library
set(TINYXML_DEPS)
# Push the list to the parent scope for projects to reference
set(TINYXML_DEPS ${TINYXML_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(TINYXML_LIB_DEPS)
# Push the list to the parent scope for projects to reference
set(TINYXML_LIB_DEPS ${TINYXML_LIB_DEPS} PARENT_SCOPE)

# Add internal options if TINYXML is enabled
if(TINYXML_ENABLED)
  # Define the libraries produced by this external module

  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES tinyxml)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/include)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(TINYXMLDIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(TINYXML_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(TINYXML_BIN_DIR ${TINYXML_BIN_DIR} PARENT_SCOPE)
endif(TINYXML_ENABLED)

