# Filename: Options.cmake
# Description: Define the GLEW external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# GLEW library options
set_option(GLEW_ENABLED FALSE BOOL "Build 'GLEW' 3rdparty/external libraries?")
set_option(GLEW_SHARED_LIBRARIES TRUE BOOL "Build 'GLEW' shared libraries?")
set_option(GLEW_REVISION_TAG "" STRING "Which 'GLEW' revision/tag to use?")
set_option(GLEW_BUILD_DOCS TRUE BOOL "Build 'GLEW' documentation?")
#set_option(GLEW_BUILD_EXAMPLES FALSE BOOL "Build 'GLEW' examples?")

# Add our directory to the EXTERNAL_ARGS list for the projects to use later
set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
  -DGLEWDIR:PATH=${EXTERNAL_DIR})
