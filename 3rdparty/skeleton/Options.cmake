# Filename: Options.cmake
# Description: This is an example of the options file for a 3rd party/external
#   library. The name of the options MUST be the name of the subdirectory where
#   these files live (e.g. GQE, SFML, THOR, etc). Modify the library options
#   below for your needs. The only required option is the @DIR_NAME@_ENABLED
#   option which determines if the 3rdparty/external library is even necessary.
# Modification Log:
# 2012-02-03 Initial version
#

# SKELETON library options
set_option(SKELETON_ENABLED FALSE BOOL "Build 'SKELETON' 3rdparty/external libraries?")
set_option(SKELETON_SHARED_LIBRARIES TRUE BOOL "Build 'SKELETON' shared libraries?")
set_option(SKELETON_REVISION_TAG "" STRING "Which 'SKELETON' revision/tag to use?")
set_option(SKELETON_BUILD_DOCS TRUE BOOL "Build 'SKELETON' documentation?")
set_option(SKELETON_BUILD_EXAMPLES FALSE BOOL "Build 'SKELETON' examples?")
set_option(SKELETON_URL
  "https://RyanLindeman@code.google.com/p/gqe"
  STRING
  "URL to obtain latest 'SKELETON' version")

# Add internal options if SFML is enabled
if(SKELETON_ENABLED)
  # Add our directory to the EXTERNAL_ARGS list for the projects to use later
  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
    -DSKELETONDIR:PATH=${EXTERNAL_DIR})

  # Define compiler definitions to be used by projects that use SKELETON
  #if(SKELETON_SHARED_LIBRARIES)
  #  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
  #    -DSKELETON_DEFS:STRING=-DSKELETON_DYNAMIC)
  #else(SKELETON_SHARED_LIBRARIES)
  #  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
  #    -DSKELETON_DEFS:STRING=-DSKELETON_STATIC)
  #endif(SKELETON_SHARED_LIBRARIES)
endif(SKELETON_ENABLED)

