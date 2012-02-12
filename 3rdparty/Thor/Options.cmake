# Filename: Options.cmake
# Description: Define the Thor external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# Thor library options
set_option(THOR_ENABLED TRUE BOOL "Build 'Thor' 3rdparty/external libraries?")
# The static libraries option for THOR doesn't seem to work yet
set_option(THOR_SHARED_LIBRARIES TRUE BOOL "Build 'Thor' shared libraries?")
set_option(THOR_REVISION_TAG "" STRING "Which 'Thor' revision/tag to use?")
set_option(THOR_BUILD_DOCS TRUE BOOL "Build 'Thor' documentation?")
set_option(THOR_BUILD_EXAMPLES FALSE BOOL "Build 'Thor' examples?")
set_option(THOR_URL
  "http://www.bromeon.ch/svn/thor/trunk"
  STRING
  "SVN URL to obtain latest 'Thor' version")

# Add internal options if THOR is enabled
if(THOR_ENABLED)
  # Add our directory to the EXTERNAL_ARGS list for the projects to use later
  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
    -DTHORDIR:PATH=${EXTERNAL_DIR})

  # Define Thor compiler definitions to be used by projects that use Thor
  #if(THOR_SHARED_LIBRARIES)
  #  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
  #    -DTHOR_DEFS:STRING=-DTHOR_DYNAMIC)
  #else(THOR_SHARED_LIBRARIES)
  #  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
  #    -DTHOR_DEFS:STRING=-DTHOR_STATIC)
  #endif(THOR_SHARED_LIBRARIES)
endif(THOR_ENABLED)

