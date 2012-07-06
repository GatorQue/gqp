# - Find tinyxml
# Find the native tinyxml includes and libraries
#
#  TINYXML_INCLUDE_DIR - where to find tinyxml/Config.hpp, etc.
#  TINYXML_LIBRARIES   - List of libraries when using libtinyxml.
#  TINYXML_FOUND       - True if libtinyxml found.

if(TINYXML_INCLUDE_DIR)
  # Already in cache, be silent
  set(TINYXML_FIND_QUIETLY TRUE)
endif(TINYXML_INCLUDE_DIR)

# deduce the libraries suffix from the options
set(FIND_LIB_SUFFIX "")
if(NOT BUILD_SHARED_LIBRARIES)
  set(FIND_LIB_SUFFIX "${FIND_LIB_SUFFIX}-s")
endif()

find_path(TINYXML_INCLUDE_DIR tinyxml.h
  PATH_SUFFIXES tinyxml
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw          # Fink
  /opt/local   # DarwinPorts
  /opt/csw     # Blastwave
  /opt
  ${TINYXMLDIR}/include
  $ENV{TINYXMLDIR}/include)

find_library(TINYXML_LIBRARY_DEBUG
  tinyxml-d${FIND_LIB_SUFFIX}
  PATH_SUFFIXES lib64 lib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw          # Fink
  /opt/local   # DarwinPorts
  /opt/csw     # Blastwave
  /opt
  ${TINYXMLDIR}
  $ENV{TINYXMLDIR})

find_library(TINYXML_LIBRARY_RELEASE
  tinyxml${FIND_LIB_SUFFIX}
  PATH_SUFFIXES lib64 lib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw          # Fink
  /opt/local   # DarwinPorts
  /opt/csw     # Blastwave
  /opt
  ${TINYXMLDIR}
  $ENV{TINYXMLDIR})

if(TINYXML_LIBRARY_DEBUG OR TINYXML_LIBRARY_RELEASE)
  # Library found
  set(TINYXML_FOUND TRUE)

  # If both were found, set TINYXML_LIBRARY to the release version
  if(TINYXML_LIBRARY_DEBUG AND TINYXML_LIBRARY_RELEASE)
    set(TINYXML_LIBRARY ${TINYXML_LIBRARY_RELEASE})
  endif()

  if(TINYXML_LIBRARY_DEBUG AND NOT TINYXML_LIBRARY_RELEASE)
    set(TINYXML_LIBRARY ${TINYXML_LIBRARY_DEBUG})
  endif()

  if(NOT TINYXML_LIBRARY_DEBUG AND TINYXML_LIBRARY_RELEASE)
    set(TINYXML_LIBRARY ${TINYXML_LIBRARY_RELEASE})
  endif()
else()
  set(TINYXML_FOUND FALSE)
endif()

# Handle the QUIETLY and REQUIRED arguments and set SNDFILE_FOUND to TRUE if
# all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TINYXML DEFAULT_MSG TINYXML_LIBRARY TINYXML_INCLUDE_DIR)

if(TINYXML_FOUND)
  set(TINYXML_LIBRARIES ${TINYXML_LIBRARY})
else(TINYXML_FOUND)
  set(TINYXML_LIBRARIES)
endif(TINYXML_FOUND)

mark_as_advanced(TINYXML_INCLUDE_DIR
  TINYXML_LIBRARY
  TINYXML_LIBRARY_RELEASE
  TINYXML_LIBRARY_DEBUG)
