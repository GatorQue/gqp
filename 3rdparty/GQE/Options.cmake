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
set_option(GQE_BUILD_EXAMPLES FALSE BOOL "Build 'GQE' examples?")
set_option(GQE_URL
  "https://RyanLindeman@code.google.com/p/gqe"
  STRING
  "Mercurial URL to obtain latest 'GQE' version")

# Add internal options if GQE is enabled
if(GQE_ENABLED)
  # Add our directory to the EXTERNAL_ARGS list for the projects to use later
  set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
    -DGQEDIR:PATH=${EXTERNAL_DIR})

  # Define GQE definitions to be used by projects that use GQE
  if(GQE_SHARED_LIBRARIES)
    set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
      -DGQE_DEFS:STRING=-DGQE_DYNAMIC)
  else(GQE_SHARED_LIBRARIES)
    set(EXTERNAL_ARGS ${EXTERNAL_ARGS}
      -DGQE_DEFS:STRING=-DGQE_STATIC)
  endif(GQE_SHARED_LIBRARIES)
endif(GQE_ENABLED)

