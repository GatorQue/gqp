# Filename: Options.cmake
# Description: Define the GQE external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# GQE library options
set_option(GQE_ENABLED TRUE BOOL "Build 'GQE' 3rdparty/external libraries?")
set_option(GQE_SHARED_LIBRARIES TRUE BOOL "Build 'GQE' shared libraries?")
set_option(GQE_REVISION_TAG "" STRING "Which 'GQE' revision/tag to use?")
set_option(GQE_BUILD_DOCS TRUE BOOL "Build 'GQE' documentation?")
set_option(GQE_BUILD_EXAMPLES TRUE BOOL "Build 'GQE' examples?")

# Add our directory to the EXTERNAL_ARGS list for the projects to use later
set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
  -DGQEDIR:PATH=${CMAKE_SOURCE_DIR}/external)
