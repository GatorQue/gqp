# Filename: Options.cmake
# Description: Define the SFML external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# SFML library options
set_option(SFML_ENABLED TRUE BOOL "Build 'SFML' 3rdparty/external libraries?")
set_option(SFML_SHARED_LIBRARIES TRUE BOOL "Build 'SFML' shared libraries?")
set_option(SFML_USE_LATEST FALSE BOOL "Use 'SFML' version 2.x from GIT repository?")
set_option(SFML_REVISION_TAG "" STRING "Which 'SFML' revision/tag to use?")
set_option(SFML_BUILD_DOCS TRUE BOOL "Build 'SFML' documentation?")
set_option(SFML_BUILD_EXAMPLES FALSE BOOL "Build 'SFML' examples?")

# Determine which URL to use to obtain the SFML source files
if(SFML_USE_LATEST)
  set_option(SFML_URL
    "https://github.com/LaurentGomila/SFML.git"
    STRING
    "Git URL for getting latest 'SFML' version")
else(SFML_USE_LATEST)
  set_option(SFML_URL
    "http://gqe.googlecode.com/files/SFML-1.6.2-cmake.zip"
    STRING
    "URL for getting older 'SFML' version")
endif(SFML_USE_LATEST)

# Add internal options if SFML is enabled
if(SFML_ENABLED)
  # Add our directory to the EXTERNAL_ARGS list for the projects to use later
  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
    -DSFMLDIR:PATH=${EXTERNAL_DIR})

  # Define SFML definitions to be used by projects that use SFML
  if(SFML_SHARED_LIBRARIES)
    set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
      -DSFML_DEFS:STRING=-DSFML_DYNAMIC)
  else(SFML_SHARED_LIBRARIES)
    set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
      -DSFML_DEFS:STRING=-DSFML_STATIC)
  endif(SFML_SHARED_LIBRARIES)
endif(SFML_ENABLED)

