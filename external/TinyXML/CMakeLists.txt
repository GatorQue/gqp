# Filename: CMakeLists.txt
# Description: This will download either the latest TINYXML version or the
#   previous version and setup dependencies so the libraries will be built and
#   copied to the EXTERNAL_DIR folder for projects and other libraries to use.
# Modification Log:
# 2012-05-25 Initial version
#

# Define the project name (current directory)
project(${EXTERNAL_CMAKE_DIR})

# Step 1: Determine which version to download for this module
if(NOT EXISTS ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR})
  # Step 1a: Get the previous version
  DownloadFile(${TINYXML_URL}
    ${PROJECT_BINARY_DIR}/download.zip
    30)

  # Step 1b: Extract download zip file to clone directory
  ExtractFile(${PROJECT_BINARY_DIR}/download.zip
    ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR})

  # Step 1c: Create a CMakeLists.txt file to build this external library
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/CMakeLists-build.txt
    ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR}/CMakeLists.txt)
else(NOT EXISTS ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR})
  # TODO: Add "update from repository" or skip build below step
endif(NOT EXISTS ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR})

# Step 2a: Define some custom variables that define this modules build
set(OLD_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(BUILD_SHARED_LIBS ${TINYXML_SHARED_LIBRARIES})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)

# Step 2b: Add the clone directory to be built
add_subdirectory(${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR}
  ${PROJECT_BINARY_DIR}/clone)

# Step 3a: Define which directories to copy to EXTERNAL_DIR and its folders
set(COPY_TINYXML_BIN
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/bin
  ${EXTERNAL_BIN_DIR})
set(COPY_TINYXML_LIB
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/lib
  ${EXTERNAL_LIB_DIR})
set(COPY_TINYXML_INCLUDE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/include
  ${EXTERNAL_INCLUDE_DIR})
set(COPY_TINYXML_DOC
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/doc
  ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
set(COPY_TINYXML_CMAKE
  -E copy
  ${PROJECT_SOURCE_DIR}/Findtinyxml.cmake
  ${EXTERNAL_MODULES_DIR})
set(COPY_TINYXML_EXAMPLES
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/examples
  ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME})
set(COPY_TINYXML_LICENSE
  -E copy
  ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_NAME}/readme.txt
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
  COMMAND ${CMAKE_COMMAND} ${COPY_TINYXML_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_TINYXML_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_TINYXML_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_TINYXML_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_TINYXML_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_TINYXML_EXAMPLES}
  COMMAND ${CMAKE_COMMAND} ${COPY_TINYXML_LICENSE}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/clone
  VERBATIM)

# Step 3e: Add each library provided by this module as a dependency
foreach(MODULE_LIB ${${EXTERNAL_NAME}_LIBS})
  add_dependencies(INSTALL-${PROJECT_NAME} ${MODULE_LIB})
endforeach(MODULE_LIB ${${EXTERNAL_NAME}_LIBS})

# Step 3f: Add example dependency for this module
if(TINYXML_BUILD_EXAMPLES)
  foreach(EXAMPLE_NAME ${${EXTERNAL_NAME}_EXAMPLES})
    add_dependencies(INSTALL-${PROJECT_NAME} ${EXAMPLE_NAME})
  endforeach()
endif(TINYXML_BUILD_EXAMPLES)

# Step 4: Restore any global build settings changed
set(BUILD_SHARED_LIBS ${OLD_BUILD_SHARED_LIBS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})

