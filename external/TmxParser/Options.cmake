# Filename: Options.cmake
# Description: Define the TmxParser external 3rd party library options used in
#   the CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# TmxParser library options
set_option(TMXPARSER_ENABLED TRUE BOOL "Build 'TmxParser' 3rdparty/external libraries?")
if(WINDOWS)
  # TmxParser doesn't yet support Shared libraries for windows
  set_option(TMXPARSER_SHARED_LIBRARIES FALSE BOOL "Build 'TmxParser' shared libraries?")
else(WINDOWS)
  set_option(TMXPARSER_SHARED_LIBRARIES TRUE BOOL "Build 'TmxParser' shared libraries?")
endif(WINDOWS)
set_option(TMXPARSER_REVISION_TAG "" STRING "Which 'TmxParser' revision/tag to use?")
set_option(TMXPARSER_BUILD_DOCS FALSE BOOL "Build 'TmxParser' documentation?")
set_option(TMXPARSER_BUILD_EXAMPLES FALSE BOOL "Build 'TmxParser' examples?")
set_option(TMXPARSER_URL
  "http://tmx-parser.googlecode.com/svn/trunk"
  STRING
  "SVN URL to obtain latest 'TmxParser' version")

# Create a list of examples
set(TMXPARSER_EXAMPLES)

# Create a list of libraries provided by this 3rd party/external module
set(TMXPARSER_LIBS TmxParser)
# Push the list to the parent scope for projects to reference
set(TMXPARSER_LIBS ${TMXPARSER_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(TMXPARSER_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(TMXPARSER_COMPONENTS ${TMXPARSER_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
set(TMXPARSER_DEFS)
# Push the list to the parent scope for projects to reference
set(TMXPARSER_DEFS ${TMXPARSER_DEFS} PARENT_SCOPE)

# Create a list of external dependencies used by this external library
set(TMXPARSER_DEPS TINYXML ZLIB)
# Push the list to the parent scope for projects to reference
set(TMXPARSER_DEPS ${TMXPARSER_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(TMXPARSER_LIB_DEPS
  TINYXML tinyxml
  ZLIB    zlibstatic)
# Push the list to the parent scope for projects to reference
set(TMXPARSER_LIB_DEPS ${TMXPARSER_LIB_DEPS} PARENT_SCOPE)

# Add internal options if TMXPARSER is enabled
if(TMXPARSER_ENABLED)
  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES TmxParser)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/TmxParser)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(TMXPARSERDIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(TMXPARSER_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(TMXPARSER_BIN_DIR ${TMXPARSER_BIN_DIR} PARENT_SCOPE)
endif(TMXPARSER_ENABLED)

