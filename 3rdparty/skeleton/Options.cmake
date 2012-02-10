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
