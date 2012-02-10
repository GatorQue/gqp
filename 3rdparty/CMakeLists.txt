# Filename: CMakeLists.txt
# Description: CMake file for adding each external 3rd party project to the
#   build chain.
# Modification Log:
# 2012-02-04 Initial version
#

# Create a project name for the external 3rd party project files
project(GetExternal)

# Include the ExternalProject CMake macros (someone might use it)
include(ExternalProject)

# Add 3rdparty/external custom target
add_custom_target(external ALL
  DEPENDS ${PROJECT_BINARY_DIR}/external-complete)

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
set(EXTERNAL_DEPS)
foreach(EXTERNAL_CMAKE_DIR ${EXTERNAL_CMAKES})
  # Get the uppercase version of the subdirectory name
  string(TOUPPER ${EXTERNAL_CMAKE_DIR} EXTERNAL_NAME)

  # See if this 3rdparty/external library is enabled as defined in
  # Options.cmake file in the subdirectory for this 3rdparty/external library
  if(${${EXTERNAL_NAME}_ENABLED})
    # Add this 3rdparty/external library as a dependency
    set(EXTERNAL_DEPS ${EXTERNAL_DEPS} ${EXTERNAL_NAME})

    # Add the subdirectory target if enabled
    add_subdirectory(${EXTERNAL_CMAKE_DIR})
  endif()
endforeach()

# Add the complete step that depends on all the external libraries added above
add_custom_command(
  OUTPUT ${PROJECT_BINARY_DIR}/external-complete
  COMMENT "Completed building/installing 3rdparty/external files."
  COMMAND ${CMAKE_COMMAND} -E touch ${PROJECT_BINARY_DIR}/external-complete
  DEPENDS ${EXTERNAL_DEPS}
  DEPENDS ${CMAKE_SOURCE_DIR}/external
  VERBATIM)

# Install all compiled libraries, binary files, include files, and documents
# to the external folder in the source directory for our projects to use.
add_custom_command(
  OUTPUT ${CMAKE_SOURCE_DIR}/external
  COMMENT "Installing 3rdparty files into '${CMAKE_SOURCE_DIR}/external' folder"
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/bin ${EXTERNAL_BIN_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/lib ${EXTERNAL_LIB_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/include ${EXTERNAL_INCLUDE_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/src ${EXTERNAL_SRC_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/doc ${EXTERNAL_DOC_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/cmake ${EXTERNAL_CMAKE_DIR}
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_BINARY_DIR}/examples ${EXTERNAL_EXAMPLES_DIR}
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${EXTERNAL_DEPS}
  VERBATIM)
