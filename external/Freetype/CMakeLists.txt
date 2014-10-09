# Filename: CMakeLists.txt
# Description: This will install the Freetype source and include files into the
#   external library for you to reference.
# Modification Log:
# 2014-10-03 Initial version
#

# Define the project name (current directory)
project(${EXTERNAL_CMAKE_DIR})

# Step 1: Download version from repository
if(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})
  # Step 1a: Get the previous version
  DownloadFile(${FREETYPE_URL}
    ${PROJECT_BINARY_DIR}/download.zip
    30)

  # Step 1b: Extract download zip file to clone directory
  ExtractFile(${PROJECT_BINARY_DIR}/download.zip
    ${TOPLEVEL_DIR}/${PROJECT_NAME})

  # Step 1c: Replace the buggy CMakeLists.txt file with local copy until
  # better debug and release library name issues are resolved.
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/CMakeLists-replace.txt
    ${TOPLEVEL_DIR}/${PROJECT_NAME}/CMakeLists.txt)
else(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})
  # TODO: Add "update from repository" or skip build below step
endif(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})

# Step 2a: Define some custom variables that define this modules build
set(OLD_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(BUILD_SHARED_LIBS ${FREETYPE_SHARED_LIBRARIES})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)

# Step 2b: Add the clone directory to be built
add_subdirectory(${TOPLEVEL_DIR}/${PROJECT_NAME}
  ${PROJECT_BINARY_DIR}/clone)

# Step 3a: Define which directories to copy to EXTERNAL_DIR and its folders
set(COPY_FREETYPE_BIN
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/bin
  ${EXTERNAL_BIN_DIR})
set(COPY_FREETYPE_LIB
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/lib
  ${EXTERNAL_LIB_DIR})
set(COPY_FREETYPE_INCLUDE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/include
  ${EXTERNAL_INCLUDE_DIR})
set(COPY_FREETYPE_DOC
  -E copy_directory
  ${TOPLEVEL_DIR}/${PROJECT_NAME}/docs/reference
  ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
set(COPY_FREETYPE_CMAKE
  -E copy
  ${PROJECT_SOURCE_DIR}/FindFreetype.cmake
  ${EXTERNAL_MODULES_DIR})
set(COPY_FREETYPE_EXAMPLES
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/examples
  ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME})
set(COPY_FREETYPE_LICENSE
  -E copy
  ${TOPLEVEL_DIR}/${PROJECT_NAME}/docs/LICENSE.txt
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
  COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_MODULES_DIR}
  COMMAND ${CMAKE_COMMAND} ${COPY_FREETYPE_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_FREETYPE_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_FREETYPE_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_FREETYPE_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_FREETYPE_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_FREETYPE_EXAMPLES}
  COMMAND ${CMAKE_COMMAND} ${COPY_FREETYPE_LICENSE}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/clone
  VERBATIM)

# Step 3d: Add each library provided by this module as a dependency
foreach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})
  add_dependencies(INSTALL-${PROJECT_NAME} ${MODULE_NAME})
endforeach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})

# Step 3e: Add example dependency for this module
if(FREETYPE_BUILD_EXAMPLES)
  foreach(EXAMPLE_NAME ${${EXTERNAL_NAME}_EXAMPLES})
    add_dependencies(INSTALL-${PROJECT_NAME} ${EXAMPLE_NAME})
  endforeach()
endif(FREETYPE_BUILD_EXAMPLES)

# Step 4: Restore any global build settings changed
set(BUILD_SHARED_LIBS ${OLD_BUILD_SHARED_LIBS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})
