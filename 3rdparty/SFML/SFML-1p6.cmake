# Filename: SFML-1p6.txt
# Description: This will set the configure options for building the static
#   or shared SFML version 1.6 libraries.
# Modification Log:
# 2012-01-28 Initial version
#

# Create Script to download SFML version 1.6.2 cmake file
ScriptDownloadFile(${PROJECT_BINARY_DIR}/download.cmake
  "http://gqe.googlecode.com/files/SFML-1.6.2-cmake.zip"
  ${PROJECT_BINARY_DIR}/sfml-v1p6.zip
  30)

# Create Script to extract SFML version 1.6.2 source files
ScriptExtractFile(${PROJECT_BINARY_DIR}/extract.cmake
  ${PROJECT_BINARY_DIR}/sfml-v1p6.zip
  ${CLONE_DIR})

# Add a custom command to download and extract SFML version 1.6.2
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-get
  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/download.cmake
  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/extract.cmake
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-get
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  VERBATIM)

