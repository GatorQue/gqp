# Filename: CMakeLists.txt
# Description: CMake file for adding each external 3rd party project to the
#   build chain.
# Modification Log:
# 2012-02-04 Initial version
# 2012-02-11 Remove extra copy step, less duplication of files
#

# Create a project name for the external 3rd party project files
project(external)

# Add 3rdparty/external custom target to add dependencies to (see the
# projects/CMakeLists.txt file)
add_custom_target(external ALL)

# Use get_subdirs macro to find all subdirectories with a Options.cmake file
get_subdirs(EXTERNAL_OPTIONS "Options.cmake")

# Now include each Options.cmake file found
set(EXTERNAL_ARGS)
foreach(EXTERNAL_OPTION_DIR ${EXTERNAL_OPTIONS})
  include(${EXTERNAL_OPTION_DIR}/Options.cmake)
endforeach()

# Push the external CMake configure arguments to the parent scope
set(EXTERNAL_ARGS ${EXTERNAL_ARGS} PARENT_SCOPE)

# Use get_subdirs macro to find all subdirectories with a CMakeLists.txt files
get_subdirs(EXTERNAL_CMAKES "CMakeLists.txt")

# Now add each subdirectory found
foreach(EXTERNAL_CMAKE_DIR ${EXTERNAL_CMAKES})
  # Get the uppercase version of the subdirectory name
  string(TOUPPER ${EXTERNAL_CMAKE_DIR} EXTERNAL_NAME)

  # See if this 3rdparty/external library is enabled as defined in
  # Options.cmake file in the subdirectory for this 3rdparty/external library
  if(${${EXTERNAL_NAME}_ENABLED})
    # Add the subdirectory target if enabled
    add_subdirectory(${EXTERNAL_CMAKE_DIR})
  endif()
endforeach()

