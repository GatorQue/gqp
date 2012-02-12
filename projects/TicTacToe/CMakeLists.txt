# Filename: CMakeLists.txt
# Description: CMake project file for the TicTacToe project. This is an
#   example project file from which you can see how things work all work
#   together to provide you the ability to create video games using both
#   GQE and SFML together. I have tried to make it as painless as possible
#   to add your own projects to GQE and SFML. Just edit a few items in this
#   file to get your own project started.
# Modification Log:
# 2012-02-06 Initial version
# 2012-02-11 Fix typo and added source files checking
#

# We require no less than version 2.8 for CMake
cmake_minimum_required(VERSION 2.8)

# Set default build type first before calling project() instruction
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build (Debug or Release)" FORCE)
endif(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)

# Set our project name, which is the name of the current directory
project(${SUBPROJECT_NAME})

# Establish our version numbers for this project
set(PROJECT_VERSION_MAJOR 1)
set(PROJECT_NAME_VERSION_MINOR 0)
set(PROJECT_NAME_VERSION_PATCH 0)
set(PROJECT_NAME_VERSION
  "${PROJECT_NAME_VERSION_MAJOR}.${PROJECT_NAME_VERSION_MINOR}.${PROJECT_NAME_VERSION_PATCH}")

# Include the top level macros to be used by all projects
include(${TOPLEVEL_DIR}/cmake/Macros.cmake)

# Include the top level functions to be used by all projects
include(${TOPLEVEL_DIR}/cmake/Functions.cmake)

# Include the top level options to be used by all projects
include(${TOPLEVEL_DIR}/cmake/Options.cmake)

# Include our options file
include(${CMAKE_CURRENT_LIST_DIR}/Options.cmake)

# If this project has 3rdparty/external dependencies, extract them now
if(${PROJECT_NAME}_3RDPARTY_DEPENDS AND
    ${PROJECT_NAME}_3RDPARTY_COMPONENTS)
  # Get the required 3rdparty/external libraries for this project
  parse_arguments(THIS
    "${${PROJECT_NAME}_3RDPARTY_DEPENDS}" ""
    ${${PROJECT_NAME}_3RDPARTY_COMPONENTS})
endif()

# Find each of the required 3rdparty/external libraries using find_package
set(${PROJECT_NAME}_LIBS)
foreach(EXTERNAL_PACKAGE ${${PROJECT_NAME}_3RDPARTY_DEPENDS})
  # Try to find the 3rdparty/external library and its components
  find_package(${EXTERNAL_PACKAGE} REQUIRED ${THIS_${EXTERNAL_PACKAGE}})

  # Add the include directories to our list of include directories
  include_directories(${${EXTERNAL_PACKAGE}_INCLUDE_DIR})

  # Add the definitions to our list of definitions
  if(${EXTERNAL_PACKAGE}_DEFINITIONS)
    add_definitions(${${EXTERNAL_PACKAGE}_DEFINITIONS})
  endif(${EXTERNAL_PACKAGE}_DEFINITIONS)

  # See if definitions were passed as an argument to CMake
  if(${EXTERNAL_PACKAGE}_DEFS)
    add_definitions(${${EXTERNAL_PACKAGE}_DEFS})
  endif(${EXTERNAL_PACKAGE}_DEFS)

  # Add these libraries to our list of dependencies
  set(${PROJECT_NAME}_LIBS ${${PROJECT_NAME}_LIBS} ${${EXTERNAL_PACKAGE}_LIBRARIES})
endforeach()

# Now add the project source files and targets
file(GLOB_RECURSE ${PROJECT_NAME}_SOURCES
  ${PROJECT_SOURCE_DIR}/src/*.c++
  ${PROJECT_SOURCE_DIR}/src/*.cpp
  ${PROJECT_SOURCE_DIR}/src/*.cxx
  ${PROJECT_SOURCE_DIR}/src/*.cc
  ${PROJECT_SOURCE_DIR}/src/*.c)

# Add executable if source files were found
if(${PROJECT_NAME}_SOURCES)
  # Add a target to build the source files
  add_executable(${PROJECT_NAME} ${${PROJECT_NAME}_SOURCES})

  # Set the debug suffix
  set_target_properties(${PROJECT_NAME} PROPERTIES DEBUG_POSTFIX -d)

  # For GCC 4.x on Windows, apply the BUILD_STATIC_STD_LIBS option if it is enabled
  if(WINDOWS AND COMPILER_GCC AND BUILD_STATIC_STD_LIBS)
    if(${GCC_VERSION} MATCHES "4\\..*")
      set_target_properties(${PROJECT_NAME} PROPERTIES LINK_FLAGS "-static-libgcc -static-libstdc++")
    endif()
  endif()

  # Add the 3rdparty/external libraries to our target's linker list
  if(${PROJECT_NAME}_LIBS)
    target_link_libraries(${PROJECT_NAME} ${${PROJECT_NAME}_LIBS})
  endif(${PROJECT_NAME}_LIBS)

  # Copy binary files from external bin directory to build folder
  add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${EXTERNAL_BIN_DIR}
    ${PROJECT_BINARY_DIR}/${CMAKE_CFG_INTDIR})

  # Copy resources folder to build directory after build
  add_custom_command(TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${PROJECT_SOURCE_DIR}/resources
    ${PROJECT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/resources)
endif(${PROJECT_NAME}_SOURCES)

# Add docmentation folder if it exists
if(EXISTS ${PROJECT_SOURCE_DIR}/doc)
  set(PROJECT_DOC_DIR ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
  add_subdirectory(${PROJECT_SOURCE_DIR}/doc)
endif()

