# Filename: SFML-2pX.cmake
# Description: This will set the configure options for building the static
#   or shared SFML version 2.x libraries from GIT source.
# Modification Log:
# 2012-01-28 Initial version
#

# Create Script to clone SFML library
ScriptCloneGit(${PROJECT_BINARY_DIR}/clone.cmake
  "https://github.com/LaurentGomila/SFML.git"
  ${CLONE_DIR}
  ${SFML_REVISION_TAG})

# Add a custom command to clone the GIT repository
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-get
  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/clone.cmake
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-get
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  VERBATIM)

