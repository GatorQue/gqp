# Filename: CMakeLists.txt
# Description: CMake top level project file for building everything. This
#   includes downloading 3rd party libraries, all projects in the projects
#   folder, and example programs.
# Modification Log:
# 2012-01-03 Initial version
# 2012-03-23 Change from 3rdparty to external
#

# We require no less than version 2.8 for CMake
cmake_minimum_required(VERSION 2.8)

# Set our project name as TopLevel
project(TopLevel)

# Set default build type first before calling project() instruction
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build (Debug or Release)" FORCE)
endif(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)

# Define the path of our additional External CMake modules
set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)

# Include the top level macros to be used by all projects
include(${PROJECT_SOURCE_DIR}/cmake/Macros.cmake)

# Include the top level functions to be used by all projects
include(${PROJECT_SOURCE_DIR}/cmake/Functions.cmake)

# Include the top level options to be used by all projects
include(${PROJECT_SOURCE_DIR}/cmake/Options.cmake)

# Add the external/3rd party directory first
add_subdirectory(external)

# Add the projects folder next
add_subdirectory(projects)

