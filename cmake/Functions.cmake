# Filename: Functions.cmake
# Description: Useful functions for building scripts and sources.
# Modification Log:
# 2012-01-28 Initial version
# 2012-03-23 Added Actions.cmake script file
# 2012-10-26 Special fix for cmake versions 2.8.0 to 2.8.3
#

# Create CMAKE_CURRENT_LIST_DIR if it doesn't exist (pre 2.8.4)
if(NOT DEFINED CMAKE_CURRENT_LIST_DIR)
  get_filename_component(CMAKE_CURRENT_LIST_DIR
    ${CMAKE_CURRENT_LIST_FILE} PATH)
endif(NOT DEFINED CMAKE_CURRENT_LIST_DIR)

# Action script for performing functions during CMake parsing
include(${CMAKE_CURRENT_LIST_DIR}/Actions.cmake)

# Script script for creating scripts to perform functions during make process
include(${CMAKE_CURRENT_LIST_DIR}/Scripts.cmake)

