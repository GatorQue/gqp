# Filename: Options.cmake
# Description: Define various CMake build options for all projects
# Modification Log:
# 2012-01-02 Initial version
# 2012-02-11 Change CMAKE to MODULES and added License directory
# 2012-03-23 Various fixes to GQP options
#

# Option: TARGET_ARCH_TYPE
# Description: Target architecture type.
# Values:
#   x86 - 32 bit x86 architecture
#   x64 - 64 bit x86 architecture
set_option(TARGET_ARCH_TYPE "x86" STRING "Target architecture type (x86 or x64)")
if(TARGET_ARCH_TYPE STREQUAL "x86")
  set(TARGET_ARCH_32BITS 1)
elseif(TARGET_ARCH_TYPE STREQUAL "x64")
  set(TARGET_ARCH_64BITS 1)
else()
  message(FATAL_ERROR "error: Unsupported/Unknwon TARGET_ARCH_TYPE '${TARGET_ARCH_TYPE}'")
endif()

# Option: TOPLEVEL_DIR
# Description: The top level GatorQue Projects directory which is used as the
# reference directory for all other directory references.
# Value: ${PROJECT_SOURCE_DIR} if not yet defined
if(NOT DEFINED TOPLEVEL_DIR)
  set_option(TOPLEVEL_DIR ${PROJECT_SOURCE_DIR} PATH "Top level directory")
endif(NOT DEFINED TOPLEVEL_DIR)

# Option: EXTERNAL_DIR
# Description: The directory to store all 3rdparty/external libraries, binary
# files, and documentation after they have been built.
# Value: ${TOPLEVEL_DIR}/3rdparty
if(NOT DEFINED EXTERNAL_DIR)
  set_option(EXTERNAL_DIR ${TOPLEVEL_DIR}/3rdparty PATH "3rdparty libaries folder path")
endif(NOT DEFINED EXTERNAL_DIR)

# Option: TOUCH_DIR
# Description: The directory in which touch files will be created
# Value: ${PROJECT_BINARY_DIR}/touch
if(NOT DEFINED TOUCH_DIR)
  set_option(TOUCH_DIR ${PROJECT_BINARY_DIR}/touch PATH "Build directory path for touch files")
endif(NOT DEFINED TOUCH_DIR)

# Create the TOUCH directory
file(MAKE_DIRECTORY ${TOUCH_DIR})

# Define other directory values based on EXTERNAL_DIR
set(EXTERNAL_BIN_DIR ${EXTERNAL_DIR}/bin)
set(EXTERNAL_DOC_DIR ${EXTERNAL_DIR}/doc)
set(EXTERNAL_EXAMPLES_DIR ${EXTERNAL_DIR}/examples)
set(EXTERNAL_INCLUDE_DIR ${EXTERNAL_DIR}/include)
set(EXTERNAL_LIB_DIR ${EXTERNAL_DIR}/lib)
set(EXTERNAL_LICENSE_DIR ${EXTERNAL_DIR})
set(EXTERNAL_MODULES_DIR ${EXTERNAL_DIR}/cmake/Modules)
set(EXTERNAL_SRC_DIR ${EXTERNAL_DIR}/src)

# Option: USE_PRECOMPILED_EXTERNAL
# Description: If a precompiled version is available for an external library
# then use it instead of downloading and compiling a local copy of the
# external library.
# Value: TRUE
set_option(USE_PRECOMPILED_EXTERNAL TRUE BOOL "Use precompiled external library if found?")

# Add our Modules subfolder to the CMAKE_MODULE_PATH
if(USE_PRECOMPILED_EXTERNAL)
  set(CMAKE_MODULE_PATH ${EXTERNAL_MODULES_DIR} ${CMAKE_BINARY_DIR}/Modules ${CMAKE_MODULE_PATH})
else(USE_PRECOMPILED_EXTERNAL)
  set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR}/Modules ${CMAKE_MODULE_PATH})
endif(USE_PRECOMPILED_EXTERNAL)

# Detect the host architecture
include(CheckTypeSize)
check_type_size(void* SIZEOF_VOID_PTR)
if(${SIZEOF_VOID_PTR} MATCHES "^4$")
  set(HOST_ARCH_32BITS 1)
  set(HOST_ARCH_TYPE "x86")
else()
  set(HOST_ARCH_64BITS 1)
  set(HOST_ARCH_TYPE "x64")
endif()

# Detect the host operating system
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
  set(WINDOWS 1)
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set(LINUX 1)
elseif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(MACOSX 1)
else()
  message(FATAL_ERROR "Unsupported operating system ${CMAKE_SYSTEM_NAME}")
endif()

# Detect the compiler and its version
if(CMAKE_COMPILER_IS_GNUCXX)
  set(COMPILER_GCC 1)
  execute_process(COMMAND "${CMAKE_CXX_COMPILER}" "-dumpversion" OUTPUT_VARIABLE GCC_VERSION_OUTPUT)
  string(REGEX REPLACE "([0-9]+\\.[0-9]+).*" "\\1" GCC_VERSION "${GCC_VERSION_OUTPUT}")
elseif(MSVC_VERSION EQUAL 1400)
  set(COMPILER_MSVC 2005)
  # Add some include files missing in MSVC 2005
  include_directories(${TOPLEVEL_DIR}/include/msvc)
elseif(MSVC_VERSION EQUAL 1500)
  set(COMPILER_MSVC 2008)
  # Add some include files missing in MSVC 2008
  include_directories(${TOPLEVEL_DIR}/include/msvc)
elseif(MSVC_VERSION EQUAL 1600)
  set(COMPILER_MSVC 2010)
else()
  message(WARNING "Unsupported compiler")
  return()
endif()

# Detect the build tool information
if(CMAKE_BUILD_TOOL MATCHES "nmake" OR
   CMAKE_BUILD_TOOL MATCHES "make" OR
   CMAKE_BUILD_TOOL MATCHES "gmake")
  # Build debug and release libraries separately?
  set(BUILD_SEPARATE TRUE)
else()
  # Build tools don't allow separate build of debug and release
  set(BUILD_SINGLE TRUE)
endif()

# Add our external folder include file to the include path
include_directories(${EXTERNAL_INCLUDE_DIR})
if(WINDOWS)
  # Where will compiler find BIN and LIB files?
  set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${EXTERNAL_BIN_DIR})
  set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${EXTERNAL_LIB_DIR})

  # GCC compiler on windows
  if(COMPILER_GCC)
    # require proper c++
    ADD_DEFINITIONS("-Wall -pedantic")

  # Microsoft Visual Studio compilers
  elseif(COMPILER_MSVC)

    # remove SL security warnings with Visual C++
    add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

    # for VC++, we can apply it globally by modifying the compiler flags
    if(BUILD_STATIC_STD_LIBS)
      foreach(flag
              CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
              CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
        if(${flag} MATCHES "/MD")
          string(REGEX REPLACE "/MD" "/MT" ${flag} "${${flag}}")
        endif()
      endforeach()
    endif()
  endif()
elseif(LINUX)
  # Where will compiler find BIN and LIB files?
  set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${EXTERNAL_BIN_DIR})
  set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${EXTERNAL_LIB_DIR})

  # require proper c++
  ADD_DEFINITIONS("-Wall -pedantic")
elseif(MACOSX)
  # Where will compiler find BIN and LIB files?
  set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${EXTERNAL_BIN_DIR})
  set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${EXTERNAL_LIB_DIR})

  # require proper c++
  ADD_DEFINITIONS("-Wall -pedantic")
endif()

# Add additional doxygen paths for MacOSX
if(MACOSX)
  set(ADDITIONAL_PATHS
      /Developer/Applications/Doxygen.app/Contents/Resources
      /Developer/Applications/Doxygen.app/Contents/MacOS
      $ENV{HOME}/Applications/Doxygen.app/Contents/Resources
      $ENV{HOME}/Applications/Doxygen.app/Contents/MacOS
      $ENV{HOME}/Applications/Developer/Doxygen.app/Contents/Resources
      $ENV{HOME}/Applications/Developer/Doxygen.app/Contents/MacOS)

  set(CMAKE_PROGRAM_PATH ${CMAKE_PROGRAM_PATH} ${ADDITIONAL_PATHS})
endif()

# See if Doxygen is available for building documentation
find_package(Doxygen)

# If Doxygen was found, look for the HHC program for creating CHM files on Windows
if(DOXYGEN_FOUND)
  # See if we can generate the CHM documentation
  if(WINDOWS)
    # if HHC is found, we can generate the CHM (compressed HTML) output
    find_program(DOXYGEN_HHC_PROGRAM
                 NAMES hhc.exe
                 PATHS "c:/Program Files/HTML Help Workshop"
                 DOC "HTML Help Compiler program")
    if(DOXYGEN_HHC_PROGRAM)
      set(DOXYGEN_GENERATE_HTMLHELP YES)
    else()
      set(DOXYGEN_GENERATE_HTMLHELP NO)
    endif()
  else(WINDOWS)
    # We are not running on Windows, set the values to sane defaults
    set(DOXYGEN_HHC_PROGRAM)
    set(DOXYGEN_GENERATE_HTMLHELP NO)
  endif(WINDOWS)
endif(DOXYGEN_FOUND)

# Make paths absolute (needed later on)
foreach(p BIN LIB DOC INCLUDE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

