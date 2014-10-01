# - Find SDL2
# Find the native SDL2 includes and libraries
#
#  SDL2_INCLUDE_DIR - where to find SDL.h, etc.
#  SDL2_LIBRARIES   - List of libraries when using libSDL2.
#  SDL2_FOUND       - True if libSDL2 found.

if(SDL2_INCLUDE_DIR)
  # Already in cache, be silent
  set(SDL2_FIND_QUIETLY TRUE)
endif(SDL2_INCLUDE_DIR)

find_path(SDL2_INCLUDE_DIR SDL.h
  PATH_SUFFIXES SDL2
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw          # Fink
  /opt/local   # DarwinPorts
  /opt/csw     # Blastwave
  /opt
  ${SDL2DIR}/include
  $ENV{SDL2DIR}/include)

find_library(SDL2_LIBRARY_DEBUG
  NAMES SDL2-d SDL2-s-d
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
  ${SDL2DIR}
  $ENV{SDL2DIR})

find_library(SDL2_LIBRARY_RELEASE
  NAMES SDL2 SDL2-s
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
  ${SDL2DIR}
  $ENV{SDL2DIR})

if(SDL2_LIBRARY_DEBUG OR SDL2_LIBRARY_RELEASE)
  # Library found
  set(SDL2_FOUND TRUE)

  # If both were found, set SDL2_LIBRARY to the release version
  if(SDL2_LIBRARY_DEBUG AND SDL2_LIBRARY_RELEASE)
    # This causes problems with building under NMake Makefiles (command line Visual Studio)
    set(SDL2_LIBRARY debug ${SDL2_LIBRARY_DEBUG}
      optimized ${SDL2_LIBRARY_RELEASE})
  endif()

  if(SDL2_LIBRARY_DEBUG AND NOT SDL2_LIBRARY_RELEASE)
    set(SDL2_LIBRARY ${SDL2_LIBRARY_DEBUG})
  endif()

  if(NOT SDL2_LIBRARY_DEBUG AND SDL2_LIBRARY_RELEASE)
    set(SDL2_LIBRARY ${SDL2_LIBRARY_RELEASE})
  endif()
else()
  set(SDL2_FOUND FALSE)
endif()

# Handle the QUIETLY and REQUIRED arguments and set SNDFILE_FOUND to TRUE if
# all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SDL2 DEFAULT_MSG SDL2_LIBRARY SDL2_INCLUDE_DIR)

if(SDL2_FOUND)
  set(SDL2_LIBRARIES ${SDL2_LIBRARY})
else(SDL2_FOUND)
  set(SDL2_LIBRARIES)
endif(SDL2_FOUND)

mark_as_advanced(SDL2_INCLUDE_DIR
  SDL2_LIBRARY
  SDL2_LIBRARY_RELEASE
  SDL2_LIBRARY_DEBUG)

