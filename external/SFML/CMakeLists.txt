# Filename: CMakeLists.txt
# Description: This will download either the latest SFML version or the
#   previous version and setup dependencies so the libraries will be built and
#   copied to the EXTERNAL_DIR folder for projects and other libraries to use.
# Modification Log:
# 2012-01-03 Initial version
# 2012-02-11 Add cmake module path to configure step. Also change install path
#   to a directory to prevent any future copy issues.
# 2012-03-01 Complete rewrite to allow for better Visual Studio build
#   experience that shows all files and libraries.
# 2012-05-25 Fix PROJECT_NAME issue
# 2014-10-08 Add Freetype dependency support
#

# Define the project name (current directory)
project(${EXTERNAL_CMAKE_DIR})

# Step 1: Determine which version to download for this module
if(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})
  if(SFML_USE_LATEST)
    # Step 1a: Get the latest version from Git
    CloneGit(${SFML_URL}
      ${TOPLEVEL_DIR}/${PROJECT_NAME}
      ${SFML_REVISION_TAG})

    if(WINDOWS)
      # Step 1b: Remove freetype libraries already provided by GQP
      execute_process(
        COMMAND ${CMAKE_COMMAND} -E remove ${TOPLEVEL_DIR}/${PROJECT_NAME}/extlibs/libs-msvc/x86/freetype.lib
        COMMAND ${CMAKE_COMMAND} -E remove ${TOPLEVEL_DIR}/${PROJECT_NAME}/extlibs/libs-msvc/x64/freetype.lib
        COMMAND ${CMAKE_COMMAND} -E remove ${TOPLEVEL_DIR}/${PROJECT_NAME}/extlibs/libs-mingw/x86/libfreetype.a
        COMMAND ${CMAKE_COMMAND} -E remove ${TOPLEVEL_DIR}/${PROJECT_NAME}/extlibs/libs-mingw/x64/libfreetype.a
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${TOPLEVEL_DIR}/${PROJECT_NAME}/extlibs/headers/libfreetype/windows
      )
      # Step 1c: Copy Freetype libraries already provided by GQP
      if(FREETYPE_LOCAL)
        # Copy local module FindFreetype.cmake file to SFML cmake modules directory
        execute_process(
          COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_BINARY_DIR}/Modules/FindFreetype.cmake ${TOPLEVEL_DIR}/${PROJECT_NAME}/cmake/Modules
        )
      else(FREETYPE_LOCAL)
        # Copy 3rd party library FindFreetype.cmake file to SFML cmake modules directory
        execute_process(
          COMMAND ${CMAKE_COMMAND} -E copy ${EXTERNAL_MODULES_DIR}/FindFreetype.cmake ${TOPLEVEL_DIR}/${PROJECT_NAME}/cmake/Modules
        )
      endif(FREETYPE_LOCAL)
    endif(WINDOWS)
  else(SFML_USE_LATEST)
    # Step 1a: Get the previous version
    DownloadFile(${SFML_URL}
      ${PROJECT_BINARY_DIR}/download.zip
      30)

    # Step 1b: Extract download zip file to clone directory
    ExtractFile(${PROJECT_BINARY_DIR}/download.zip
      ${TOPLEVEL_DIR}/${PROJECT_NAME})
  endif(SFML_USE_LATEST)
else(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})
  # TODO: Add "update from repository" or skip build below step
endif(NOT EXISTS ${TOPLEVEL_DIR}/${PROJECT_NAME})

# Step 2a: Define some custom variables that define this modules build
set(BUILD_DOC ${SFML_BUILD_DOCS})
set(SFML_BUILD_DOC ${SFML_BUILD_DOCS})
set(BUILD_EXAMPLES ${SFML_BUILD_EXAMPLES})
set(SFML_BUILD_EXAMPLES ${SFML_BUILD_EXAMPLES})
set(OLD_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(BUILD_SHARED_LIBS ${SFML_SHARED_LIBRARIES})
set(OLD_CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})
set(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)

# Step 2b: Add the clone directory to be built
add_subdirectory(${TOPLEVEL_DIR}/${PROJECT_NAME}
  ${PROJECT_BINARY_DIR}/clone)

# Step 3a: Define which directories to copy to EXTERNAL_DIR and its folders
set(COPY_SFML_BIN
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/bin
  ${EXTERNAL_BIN_DIR})
set(COPY_SFML_LIB
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/lib
  ${EXTERNAL_LIB_DIR})
set(COPY_SFML_INCLUDE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/include
  ${EXTERNAL_INCLUDE_DIR})
set(COPY_SFML_DOC
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/doc/html
  ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
set(COPY_SFML_CMAKE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/cmake/Modules
  ${EXTERNAL_MODULES_DIR})
set(COPY_SFML_EXAMPLES
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/examples
  ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME})
set(COPY_SFML_LICENSE
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
  COMMAND ${CMAKE_COMMAND} -E make_directory ${EXTERNAL_MODULES_DIR}
  COMMAND ${CMAKE_COMMAND} ${COPY_SFML_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_SFML_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_SFML_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_SFML_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_SFML_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_SFML_EXAMPLES}
  COMMAND ${CMAKE_COMMAND} ${COPY_SFML_LICENSE}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/clone
  VERBATIM)

# Step 3d: Add doc dependency for this module since it is not built by default
if(SFML_BUILD_DOCS AND DOXYGEN_FOUND)
  add_dependencies(INSTALL-${PROJECT_NAME} doc)
endif(SFML_BUILD_DOCS AND DOXYGEN_FOUND)

# Step 3e: Add each library provided by this module as a dependency
foreach(MODULE_LIB ${${EXTERNAL_NAME}_LIBS})
  add_dependencies(INSTALL-${PROJECT_NAME} ${MODULE_LIB})
endforeach(MODULE_LIB ${${EXTERNAL_NAME}_LIBS})

# Step 3f: Add example dependency for this module
if(SFML_BUILD_EXAMPLES)
  foreach(EXAMPLE_NAME ${${EXTERNAL_NAME}_EXAMPLES})
    add_dependencies(INSTALL-${PROJECT_NAME} ${EXAMPLE_NAME})
  endforeach()
endif(SFML_BUILD_EXAMPLES)

# Step 4: Restore any global build settings changed
set(BUILD_SHARED_LIBS ${OLD_BUILD_SHARED_LIBS})
set(CMAKE_INSTALL_PREFIX ${OLD_CMAKE_INSTALL_PREFIX})

