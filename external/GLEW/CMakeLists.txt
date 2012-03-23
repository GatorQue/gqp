# Filename: CMakeLists.txt
# Description: This will build the GLEW library which is used by SFML. The
#   reason for rebuilding the GLEW external libraries is to make sure we can
#   always use the latest versions and to fix many static linking issues that
#   occur when compiling debug builds of the GQE library and linking them
#   against the GLEW release libraries.
# Modification Log:
# 2012-01-20 Initial version
# 2012-02-11 Also change install path to a directory to prevent any future
#   copy issues.
#

# Define the GLEW project
project(${EXTERNAL_CMAKE_DIR})

# Define CMake arguments for copying build results to central directory
set(COPY_BIN
    -E copy_directory
    ${EXTERNAL_CLONE_DIR}/${EXTERNAL_CMAKE_DIR}/bin
    ${EXTERNAL_BIN_DIR})
set(COPY_LIB
    -E copy_directory
    ${EXTERNAL_CLONE_DIR}/${EXTERNAL_CMAKE_DIR}/lib
    ${EXTERNAL_LIB_DIR})
set(COPY_INCLUDE
    -E copy_directory
    ${EXTERNAL_CLONE_DIR}/${EXTERNAL_CMAKE_DIR}/include
    ${EXTERNAL_INCLUDE_DIR})
set(COPY_DOC
    -E copy_directory
    ${EXTERNAL_CLONE_DIR}/${EXTERNAL_CMAKE_DIR}/doc
    ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
set(COPY_LICENSE
  -E copy
  ${EXTERNAL_CLONE_DIR}/${EXTERNAL_CMAKE_DIR}/license.txt
  ${EXTERNAL_LICENSE_DIR}/${PROJECT_NAME}-license.txt)

# Create Download script to download the precompiled GLEW libraries
if(TARGET_ARCH_32BITS)
  ScriptDownloadFile(${PROJECT_BINARY_DIR}/download.cmake
    "http://sourceforge.net/projects/glew/files/glew/1.7.0/glew-1.7.0-win32.zip/download"
    "${PROJECT_BINARY_DIR}/glew.zip"
    30)
else(TARGET_ARCH_32BITS)
  ScriptDownloadFile(${PROJECT_BINARY_DIR}/download.cmake
    "http://sourceforge.net/projects/glew/files/glew/1.7.0/glew-1.7.0-win64.zip/download"
    "${PROJECT_BINARY_DIR}/glew.zip"
    30)
endif(TARGET_ARCH_32BITS)

# Create Extract script to extract the files downloaded
ScriptExtractFile(${PROJECT_BINARY_DIR}/extract.cmake
  "${PROJECT_BINARY_DIR}/glew.zip"
  ${EXTERNAL_CLONE_DIR}/${EXTERNAL_CMAKE_DIR})

# Add custom target for this 3rdparty/external library
add_custom_target(${PROJECT_NAME} DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-complete)

# Add the complete step first that depends on all the other steps
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-complete
  COMMENT "Completed getting and installing '${PROJECT_NAME}'"
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-download
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-extract
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-install
  VERBATIM)

# Add a custom command to download the GIT repository
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-download
  COMMENT "Downloading '${PROJECT_NAME}'"
  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/download.cmake
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-download
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  VERBATIM)

add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-extract
  COMMENT "Downloading '${PROJECT_NAME}'"
  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/extract.cmake
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-extract
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-download
  VERBATIM)

# Install the compiled libraries, binary files, include files, and documents
# to the correct folders.
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-install
  COMMENT "Installing '${PROJECT_NAME}' libraries into '${EXTERNAL_DIR}'"
  COMMAND ${CMAKE_COMMAND} ${COPY_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_LICENSE}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-install
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-download
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-extract
  VERBATIM)

