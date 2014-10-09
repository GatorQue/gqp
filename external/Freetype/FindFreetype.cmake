# - Find Freetype
# Find the native Freetype includes and libraries
#
#  FREETYPE_INCLUDE_DIR - where to find freetype2/freetype.h, etc.
#  FREETYPE_LIBRARIES   - List of libraries when using libthor.
#  FREETYPE_FOUND       - True if libthor found.

if(FREETYPE_INCLUDE_DIR)
  # Already in cache, be silent
  set(FREETYPE_FIND_QUIETLY TRUE)
endif(FREETYPE_INCLUDE_DIR)

find_path(FREETYPE_INCLUDE_DIR freetype.h
  PATH_SUFFIXES freetype2
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw          # Fink
  /opt/local   # DarwinPorts
  /opt/csw     # Blastwave
  /opt
  ${FREETYPE_DIR}/include
  $ENV{FREETYPE_DIR}/include)

find_library(FREETYPE_LIBRARY_DEBUG
  NAMES freetype-d freetype-s-d
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
  ${FREETYPE_DIR}
  $ENV{FREETYPE_DIR})

find_library(FREETYPE_LIBRARY_RELEASE
  NAMES freetype freetype-s
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
  ${FREETYPE_DIR}
  $ENV{FREETYPE_DIR})

if(FREETYPE_LIBRARY_DEBUG OR FREETYPE_LIBRARY_RELEASE)
  # Library found
  set(FREETYPE_FOUND TRUE)

  # If both were found, set FREETYPE_LIBRARY to the release version
  if(FREETYPE_LIBRARY_DEBUG AND FREETYPE_LIBRARY_RELEASE)
    set(FREETYPE_LIBRARY ${FREETYPE_LIBRARY_RELEASE})
  endif()

  if(FREETYPE_LIBRARY_DEBUG AND NOT FREETYPE_LIBRARY_RELEASE)
    set(FREETYPE_LIBRARY ${FREETYPE_LIBRARY_DEBUG})
  endif()

  if(NOT FREETYPE_LIBRARY_DEBUG AND FREETYPE_LIBRARY_RELEASE)
    set(FREETYPE_LIBRARY ${FREETYPE_LIBRARY_RELEASE})
  endif()
else()
  set(FREETYPE_FOUND FALSE)
endif()

# Handle the QUIETLY and REQUIRED arguments and set SNDFILE_FOUND to TRUE if
# all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FREETYPE DEFAULT_MSG FREETYPE_LIBRARY FREETYPE_INCLUDE_DIR)

if(FREETYPE_FOUND)
  set(FREETYPE_LIBRARIES ${FREETYPE_LIBRARY})
else(FREETYPE_FOUND)
  set(FREETYPE_LIBRARIES)
endif(FREETYPE_FOUND)

mark_as_advanced(FREETYPE_INCLUDE_DIR
  FREETYPE_LIBRARY
  FREETYPE_LIBRARY_RELEASE
  FREETYPE_LIBRARY_DEBUG)
