# - Find zlib
# Find the native zlib includes and libraries
#
#  ZLIB_INCLUDE_DIR - where to find zlib/zlib.h, etc.
#  ZLIB_LIBRARIES   - List of libraries when using libzlib.
#  ZLIB_FOUND       - True if libzlib found.

if(ZLIB_INCLUDE_DIR)
  # Already in cache, be silent
  set(ZLIB_FIND_QUIETLY TRUE)
endif(ZLIB_INCLUDE_DIR)

find_path(ZLIB_INCLUDE_DIR zlib.h
  PATH_SUFFIXES zlib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw          # Fink
  /opt/local   # DarwinPorts
  /opt/csw     # Blastwave
  /opt
  ${ZLIBDIR}/include
  $ENV{ZLIBDIR}/include)

find_library(ZLIB_LIBRARY_DEBUG
  NAMES zlib-d zlib-s-d
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
  ${ZLIBDIR}
  $ENV{ZLIBDIR})

find_library(ZLIB_LIBRARY_RELEASE
  NAMES zlib zlib-s
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
  ${ZLIBDIR}
  $ENV{ZLIBDIR})

if(ZLIB_LIBRARY_DEBUG OR ZLIB_LIBRARY_RELEASE)
  # Library found
  set(ZLIB_FOUND TRUE)

  # If both were found, set ZLIB_LIBRARY to the release version
  if(ZLIB_LIBRARY_DEBUG AND ZLIB_LIBRARY_RELEASE)
    set(ZLIB_LIBRARY ${ZLIB_LIBRARY_RELEASE})
  endif()

  if(ZLIB_LIBRARY_DEBUG AND NOT ZLIB_LIBRARY_RELEASE)
    set(ZLIB_LIBRARY ${ZLIB_LIBRARY_DEBUG})
  endif()

  if(NOT ZLIB_LIBRARY_DEBUG AND ZLIB_LIBRARY_RELEASE)
    set(ZLIB_LIBRARY ${ZLIB_LIBRARY_RELEASE})
  endif()
else()
  set(ZLIB_FOUND FALSE)
endif()

# Handle the QUIETLY and REQUIRED arguments and set SNDFILE_FOUND to TRUE if
# all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ZLIB DEFAULT_MSG ZLIB_LIBRARY ZLIB_INCLUDE_DIR)

if(ZLIB_FOUND)
  set(ZLIB_LIBRARIES ${ZLIB_LIBRARY})
else(ZLIB_FOUND)
  set(ZLIB_LIBRARIES)
endif(ZLIB_FOUND)

mark_as_advanced(ZLIB_INCLUDE_DIR
  ZLIB_LIBRARY
  ZLIB_LIBRARY_RELEASE
  ZLIB_LIBRARY_DEBUG)

