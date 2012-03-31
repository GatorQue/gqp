# Filename: CMakeLists.txt
# Description: This will install the Thor source and include files into the
#   external library for you to reference.
# Modification Log:
# 2012-03-28 Initial version
#

# Define the project name (current directory)
project(${EXTERNAL_CMAKE_DIR})

# Step 1: Download version from repository
if(NOT EXISTS ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR})
  CloneSubversion(${BOX2D_URL}
    ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR}
    ${BOX2D_REVISION_TAG})
else(NOT EXISTS ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR})
  # TODO: Add "update from repository" or skip build below step
endif(NOT EXISTS ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR})

# Step 2a: Define some custom variables that define this modules build
set(OLD_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(BUILD_SHARED_LIBS FALSE CACHE BOOL "Build shared libraries" FORCE)
set(BOX2D_BUILD_SHARED ${BOX2D_SHARED_LIBRARIES} CACHE BOOL "Build shared libraries" FORCE)
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)
set(BOX2D_INSTALL ON CACHE BOOL "Install Box2D" FORCE)
set(BOX2D_INSTALL_DOC ${BOX2D_BUILD_DOCS} CACHE BOOL "Install Documenation" FORCE)
set(LIB_INSTALL_DIR ${PROJECT_BINARY_DIR}/install)

# Step 2b: Replace the buggy CMakeLists.txt file with local copy until Issue 272
# is resolved.
execute_process(
  COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_SOURCE_DIR}/CMakeLists-replace.txt
  ${TOPLEVEL_DIR}/${PROJECT_NAME}/Box2D/Box2D/CMakeLists.txt)

# Step 2c: Add the clone directory to be built
add_subdirectory(${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR}/Box2D
  ${PROJECT_BINARY_DIR}/clone)

# Step 3a: Define which directories to copy to EXTERNAL_DIR and its folders
if(BOX2D_BUILD_SHARED)
  set(COPY_BOX2D_BIN
    -E copy
    ${PROJECT_BINARY_DIR}/install/Box2D.dll
    ${EXTERNAL_BIN_DIR})
  if(BOX2D_BUILD_EXAMPLES)
    set(COPY_BOX2D_LIB
      -E copy
      ${PROJECT_BINARY_DIR}/install/Box2D.lib
      ${EXTERNAL_LIB_DIR})
  else(BOX2D_BUILD_EXAMPLES)
    set(COPY_BOX2D_LIB
      -E make_directory
      ${EXTERNAL_LIB_DIR})
  endif(BOX2D_BUILD_EXAMPLES)
else(BOX2D_BUILD_SHARED)
  set(COPY_BOX2D_BIN
    -E make_directory
    ${EXTERNAL_BIN_DIR})
  set(COPY_BOX2D_LIB
    -E copy
    ${PROJECT_BINARY_DIR}/install/Box2D.lib
    ${EXTERNAL_LIB_DIR})
endif(BOX2D_BUILD_SHARED)
set(COPY_BOX2D_INCLUDE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/include
  ${EXTERNAL_INCLUDE_DIR})
set(COPY_BOX2D_DOC
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/share/doc/Box2D/Documentation
  ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
set(COPY_BOX2D_CMAKE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/Box2D
  ${EXTERNAL_MODULES_DIR})
if(BOX2D_BUILD_EXAMPLES)
  set(COPY_BOX2D_EXAMPLE1
    -E copy
    ${PROJECT_BINARY_DIR}/clone/HelloWorld/${CMAKE_CFG_INTDIR}/HelloWorld.exe
    ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME})
  set(COPY_BOX2D_EXAMPLE2
    -E copy
    ${PROJECT_BINARY_DIR}/clone/Testbed/${CMAKE_CFG_INTDIR}/Testbed.exe
    ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME})
else(BOX2D_BUILD_EXAMPLES)
  set(COPY_BOX2D_EXAMPLE1
    -E make_directory
    ${EXTERNAL_EXAMPLES_DIR})
  set(COPY_BOX2D_EXAMPLE2
    -E make_directory
    ${EXTERNAL_EXAMPLES_DIR})
endif(BOX2D_BUILD_EXAMPLES)
set(COPY_BOX2D_LICENSE
  -E copy
  ${TOPLEVEL_DIR}/${PROJECT_NAME}/Box2D/License.txt
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
  COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_BIN_DIR}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_LIB_DIR}
  COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_EXAMPLE1}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_EXAMPLE2}
  COMMAND ${CMAKE_COMMAND} ${COPY_BOX2D_LICENSE}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/clone
  VERBATIM)

## Step 3d: Build documentation now if enabled and Doxygen was found
#if(BOX2D_BUILD_DOCS AND DOXYGEN_FOUND)
#  if(NOT EXISTS ${TOUCH_DIR}/${PROJECT_NAME}-docs)
#    execute_process(
#      COMMAND ${DOXYGEN_EXECUTABLE} Doxyfile.txt
#      COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-docs
#      WORKING_DIRECTORY ${TOPLEVEL_DIR}/${EXTERNAL_CMAKE_DIR}/doc)
#  endif(NOT EXISTS ${TOUCH_DIR}/${PROJECT_NAME}-docs)
#endif(BOX2D_BUILD_DOCS AND DOXYGEN_FOUND)

# Step 3e: Add each library provided by this module as a dependency
foreach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})
  add_dependencies(INSTALL-${PROJECT_NAME} ${MODULE_NAME})
endforeach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})

# Step 3f: Add example dependency for this module
if(BOX2D_BUILD_EXAMPLES)
  foreach(EXAMPLE_NAME ${${EXTERNAL_NAME}_EXAMPLES})
    add_dependencies(INSTALL-${PROJECT_NAME} ${EXAMPLE_NAME})
  endforeach()
endif(BOX2D_BUILD_EXAMPLES)

# Step 4: Restore any global build settings changed
set(BUILD_SHARED_LIBS ${OLD_BUILD_SHARED_LIBS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})

