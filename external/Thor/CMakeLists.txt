# Filename: CMakeLists.txt
# Description: This will install the Thor source and include files into the
#   external library for you to reference.
# Modification Log:
# 2012-02-11 Initial version
# 2012-05-25 Fix PROJECT_NAME issue
#

# Define the project name (current directory)
project(${EXTERNAL_CMAKE_DIR})

# Step 1: Download version from repository
if(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})
  CloneSubversion(${THOR_URL}
    ${TOPLEVEL_DIR}/${PROJECT_NAME}
    ${THOR_REVISION_TAG})
else(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})
  # TODO: Add "update from repository" or skip build below step
endif(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})

# Step 2a: Define some custom variables that define this modules build
set(OLD_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(BUILD_SHARED_LIBS ${SFML_SHARED_LIBRARIES} CACHE BOOL "Build shared libraries" FORCE)
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)

# Step 2b: Add this projects clone include directory because this project used
# CMAKE_SOURCE_DIR instead of PROJECT_SOURCE_DIR which prevents it from being
# used as a subproject correctly.
include_directories(${TOPLEVEL_DIR}/${PROJECT_NAME}/include)

# Step 2c: Add the clone directory to be built
add_subdirectory(${TOPLEVEL_DIR}/${PROJECT_NAME}
  ${PROJECT_BINARY_DIR}/clone)

# Step 3a: Define which directories to copy to EXTERNAL_DIR and its folders
set(COPY_THOR_BIN
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/bin
  ${EXTERNAL_BIN_DIR})
set(COPY_THOR_LIB
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/lib
  ${EXTERNAL_LIB_DIR})
set(COPY_THOR_INCLUDE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/include
  ${EXTERNAL_INCLUDE_DIR})
set(COPY_THOR_DOC
  -E copy_directory
  ${TOPLEVEL_DIR}/${PROJECT_NAME}/doc/html
  ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
set(COPY_THOR_CMAKE
  -E copy
  ${PROJECT_SOURCE_DIR}/FindThor.cmake
  ${EXTERNAL_MODULES_DIR})
set(COPY_THOR_EXAMPLES
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/examples
  ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME})
set(COPY_THOR_LICENSE
  -E copy
  ${PROJECT_BINARY_DIR}/install/license.txt
  ${EXTERNAL_LICENSE_DIR}/${PROJECT_NAME}-license.txt)

# Step 3b: Create a custom target to install and copy the compiled libraries,
# binary files, include files, and documentation to the EXTERNAL_DIR folder
add_custom_target(INSTALL-${PROJECT_NAME}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-complete)

# Step 3c: Create a custom command to perform the "make install" command and
# copy the resulting files to the ${EXTERNAL_DIR} directory.
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-complete
  COMMENT "Installing '${PROJECT_NAME}' libraries into '${EXTERNAL_DIR}'"
  COMMAND ${CMAKE_COMMAND} -DBUILD_TYPE=$<CONFIGURATION> -P cmake_install.cmake
  COMMAND ${CMAKE_COMMAND} ${COPY_THOR_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_THOR_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_THOR_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_THOR_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_THOR_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_THOR_EXAMPLES}
  COMMAND ${CMAKE_COMMAND} ${COPY_THOR_LICENSE}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/clone
  VERBATIM)

# Step 3d: Build documentation now if enabled and Doxygen was found
if(THOR_BUILD_DOCS AND DOXYGEN_FOUND)
  if(NOT EXISTS ${TOUCH_DIR}/${PROJECT_NAME}-docs)
    execute_process(
      COMMAND ${DOXYGEN_EXECUTABLE} Doxyfile.txt
      COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-docs
      WORKING_DIRECTORY ${TOPLEVEL_DIR}/${PROJECT_NAME}/doc)
  endif(NOT EXISTS ${TOUCH_DIR}/${PROJECT_NAME}-docs)
endif(THOR_BUILD_DOCS AND DOXYGEN_FOUND)

# Step 3e: Add each library provided by this module as a dependency
foreach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})
  add_dependencies(INSTALL-${PROJECT_NAME} ${MODULE_NAME})
endforeach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})

# Step 3f: Add example dependency for this module
if(THOR_BUILD_EXAMPLES)
  foreach(EXAMPLE_NAME ${${EXTERNAL_NAME}_EXAMPLES})
    add_dependencies(INSTALL-${PROJECT_NAME} ${EXAMPLE_NAME})
  endforeach()
endif(THOR_BUILD_EXAMPLES)

# Step 4: Restore any global build settings changed
set(BUILD_SHARED_LIBS ${OLD_BUILD_SHARED_LIBS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})

