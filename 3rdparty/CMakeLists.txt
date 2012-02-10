# Filename: CMakeLists.txt
# Description: CMake file for adding each external 3rd party project to the
#   build chain.
# Modification Log:
# 2012-02-04 Initial version
#

# Create a project name for the external 3rd party project files
project(external)

# Add 3rdparty/external custom target
add_custom_target(external ALL
  DEPENDS ${EXTERNAL_DIR}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-install)

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

# Add a custom command to create the external folder
add_custom_command(
  OUTPUT ${EXTERNAL_DIR}
  COMMENT "Creating 3rdparty/external folder '${EXTERNAL_DIR}'"
  COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_DIR}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  VERBATIM)

# Add a custom command to copy all the 3rdparty/external libraries built into
# the 3rdparty/external folder for projects to find and use
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-install
  COMMENT "Installing 3rdparty files into '${EXTERNAL_DIR}' folder"
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/bin ${EXTERNAL_BIN_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/lib ${EXTERNAL_LIB_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/include ${EXTERNAL_INCLUDE_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/src ${EXTERNAL_SRC_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/doc ${EXTERNAL_DOC_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/cmake ${EXTERNAL_CMAKE_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/examples ${EXTERNAL_EXAMPLES_DIR}
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  VERBATIM)
