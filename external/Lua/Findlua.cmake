# - Find lua
# Find the native lua includes and libraries
#
#  LUA_INCLUDE_DIR - where to find lua/Config.hpp, etc.
#  LUA_LIBRARIES   - List of libraries when using liblua.
#  LUA_FOUND       - True if liblua found.

if(LUA_INCLUDE_DIR)
  # Already in cache, be silent
  set(LUA_FIND_QUIETLY TRUE)
endif(LUA_INCLUDE_DIR)

find_path(LUA_INCLUDE_DIR lua.h
  PATH_SUFFIXES lua
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw          # Fink
  /opt/local   # DarwinPorts
  /opt/csw     # Blastwave
  /opt
  ${LUADIR}/include
  $ENV{LUADIR}/include)

find_library(LUA_LIBRARY_DEBUG
  NAMES lua-d lua-s-d
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
  ${LUADIR}
  $ENV{LUADIR})

find_library(LUA_LIBRARY_RELEASE
  NAMES lua lua-s
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
  ${LUADIR}
  $ENV{LUADIR})

if(LUA_LIBRARY_DEBUG OR LUA_LIBRARY_RELEASE)
  # Library found
  set(LUA_FOUND TRUE)

  # If both were found, set LUA_LIBRARY to the release version
  if(LUA_LIBRARY_DEBUG AND LUA_LIBRARY_RELEASE)
    # This causes problems with building under NMake Makefiles (command line Visual Studio)
    set(LUA_LIBRARY debug ${LUA_LIBRARY_DEBUG}
        optimized ${LUA_LIBRARY_RELEASE})
  endif()

  if(LUA_LIBRARY_DEBUG AND NOT LUA_LIBRARY_RELEASE)
    set(LUA_LIBRARY ${LUA_LIBRARY_DEBUG})
  endif()

  if(NOT LUA_LIBRARY_DEBUG AND LUA_LIBRARY_RELEASE)
    set(LUA_LIBRARY ${LUA_LIBRARY_RELEASE})
  endif()
else()
  set(LUA_FOUND FALSE)
endif()

# Handle the QUIETLY and REQUIRED arguments and set SNDFILE_FOUND to TRUE if
# all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LUA DEFAULT_MSG LUA_LIBRARY LUA_INCLUDE_DIR)

if(LUA_FOUND)
  set(LUA_LIBRARIES ${LUA_LIBRARY})
else(LUA_FOUND)
  set(LUA_LIBRARIES)
endif(LUA_FOUND)

mark_as_advanced(LUA_INCLUDE_DIR
  LUA_LIBRARY
  LUA_LIBRARY_RELEASE
  LUA_LIBRARY_DEBUG)
