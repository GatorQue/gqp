# Filename: CMakeLists.txt
# Description: This will install the Thor source and include files into the
#   external library for you to reference.
# Modification Log:
# 2012-02-11 Initial version
#

# Define the Thor project
project(${EXTERNAL_CMAKE_DIR})

# Define CMake arguments for configuring both versions
set(CONFIG_THOR_DEBUG
  -DTHOR_BUILD_EXAMPLES:BOOL=${THOR_BUILD_EXAMPLES}
  -DBUILD_SHARED_LIBS:BOOL=${THOR_SHARED_LIBRARIES}
  -DTHOR_SHARED_LIBS:BOOL=${SFML_SHARED_LIBRARIES}
  -DSFMLDIR:PATH=${EXTERNAL_DIR}
  -DCMAKE_BUILD_TYPE:STRING=Debug
  -DCMAKE_MODULE_PATH:PATH=${EXTERNAL_MODULES_DIR}
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/install
  -G${CMAKE_GENERATOR}
  ${PROJECT_BINARY_DIR}/clone)
set(CONFIG_THOR_RELEASE
  -DTHOR_BUILD_EXAMPLES:BOOL=${THOR_BUILD_EXAMPLES}
  -DBUILD_SHARED_LIBS:BOOL=${THOR_SHARED_LIBRARIES}
  -DTHOR_SHARED_LIBS:BOOL=${SFML_SHARED_LIBRARIES}
  -DSFMLDIR:PATH=${EXTERNAL_DIR}
  -DCMAKE_BUILD_TYPE:STRING=Release
  -DCMAKE_MODULE_PATH:PATH=${EXTERNAL_MODULES_DIR}
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/install
  -G${CMAKE_GENERATOR}
  ${PROJECT_BINARY_DIR}/clone)

# Define CMake arguments for copying building both versions
set(BUILD_THOR_DEBUG
  --build ${PROJECT_BINARY_DIR}/debug
  --config ${CMAKE_CFG_INTDIR})
set(BUILD_THOR_RELEASE
  --build ${PROJECT_BINARY_DIR}/release
  --config ${CMAKE_CFG_INTDIR})

# Define CMake arguments for copying build results to central directory
set(COPY_BIN
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/bin
  ${EXTERNAL_BIN_DIR})
set(COPY_LIB
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/lib
  ${EXTERNAL_LIB_DIR})
set(COPY_INCLUDE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/include
  ${EXTERNAL_INCLUDE_DIR})
set(COPY_DOC
  -E copy_directory
  ${PROJECT_BINARY_DIR}/clone/doc/html
  ${EXTERNAL_DOC_DIR}/${PROJECT_NAME})
set(COPY_CMAKE
  -E copy
  ${PROJECT_SOURCE_DIR}/FindThor.cmake
  ${EXTERNAL_MODULES_DIR})
set(COPY_EXAMPLES
  -E copy_directory
  ${PROJECT_BINARY_DIR}/install/examples
  ${EXTERNAL_EXAMPLES_DIR}/${PROJECT_NAME})
set(COPY_LICENSE
  -E copy
  ${PROJECT_BINARY_DIR}/install/license.txt
  ${EXTERNAL_LICENSE_DIR}/${PROJECT_NAME}-license.txt)

# First see if Doxygen is available
find_package(Doxygen)

# Create Script to clone Thor library
ScriptCloneSubversion(${PROJECT_BINARY_DIR}/clone.cmake
  ${THOR_URL}
  ${PROJECT_BINARY_DIR}/clone
  ${THOR_REVISION_TAG})

# Add custom target for this 3rdparty/external library
add_custom_target(${PROJECT_NAME}
  DEPENDS SFML
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-complete)

# Add the complete step first that depends on all the other steps
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-complete
  COMMENT "Completed getting, building, and installing '${PROJECT_NAME}'"
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  DEPENDS ${PROJECT_BINARY_DIR}/clone
  DEPENDS ${PROJECT_BINARY_DIR}/debug
  DEPENDS ${PROJECT_BINARY_DIR}/release
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-debug
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-release
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-install
  VERBATIM)

# Add a custom command to download the source from the repository
add_custom_command(
  OUTPUT ${PROJECT_BINARY_DIR}/clone
  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/clone.cmake
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${PROJECT_BINARY_DIR}/debug
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${PROJECT_BINARY_DIR}/release
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  VERBATIM)

# Add a custom command to create the debug library build folder
add_custom_command(
  OUTPUT ${PROJECT_BINARY_DIR}/debug
  COMMENT "Making '${PROJECT_NAME}' debug build directory"
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/debug
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${PROJECT_BINARY_DIR}/clone
  VERBATIM)

# Build a debug build of the library
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-debug
  COMMENT "Configuring '${PROJECT_NAME}' for debug libraries"
  COMMAND ${CMAKE_COMMAND} ${CONFIG_THOR_DEBUG}
  COMMAND ${CMAKE_COMMAND} ${BUILD_THOR_DEBUG} --target install
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-debug
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/debug
  DEPENDS ${PROJECT_BINARY_DIR}/clone
  DEPENDS ${PROJECT_BINARY_DIR}/debug
  VERBATIM)

# Add a custom command to create the release library build folder
add_custom_command(
  OUTPUT ${PROJECT_BINARY_DIR}/release
  COMMENT "Making '${PROJECT_NAME}' release build directory"
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/release
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${PROJECT_BINARY_DIR}/clone
  VERBATIM)

# Build a release build of the library
if(THOR_BUILD_DOCS AND DOXYGEN_FOUND)
  # Add custom command to build the Thor documentation
  add_custom_command(
    OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-doc
    COMMENT "Building '${PROJECT_NAME}' documentation"
    COMMAND "${DOXYGEN_EXECUTABLE}" Doxyfile.txt
    COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-doc
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/clone/doc
    DEPENDS ${PROJECT_BINARY_DIR}/clone
    VERBATIM)
  add_custom_command(
    OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-release
    COMMENT "Configuring '${PROJECT_NAME}' for release libraries"
    COMMAND ${CMAKE_COMMAND} ${CONFIG_THOR_RELEASE}
    COMMAND ${CMAKE_COMMAND} ${BUILD_THOR_RELEASE} --target install
    COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/release
    DEPENDS ${PROJECT_BINARY_DIR}/clone
    DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-doc
    DEPENDS ${PROJECT_BINARY_DIR}/release
    VERBATIM)
else(THOR_BUILD_DOCS AND DOXYGEN_FOUND)
  add_custom_command(
    OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-release
    COMMENT "Configuring '${PROJECT_NAME}' for release libraries"
    COMMAND ${CMAKE_COMMAND} ${CONFIG_THOR_RELEASE}
    COMMAND ${CMAKE_COMMAND} ${BUILD_THOR_RELEASE} --target install
    COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/release
    DEPENDS ${PROJECT_BINARY_DIR}/clone
    DEPENDS ${PROJECT_BINARY_DIR}/release
    VERBATIM)
endif(THOR_BUILD_DOCS AND DOXYGEN_FOUND)

# Install the include files, documentation, and source files to the external
# folder for use my our projects.
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-install
  COMMENT "Installing '${PROJECT_NAME}' libraries into '${EXTERNAL_DIR}'"
  COMMAND ${CMAKE_COMMAND} ${COPY_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_EXAMPLES}
  COMMAND ${CMAKE_COMMAND} ${COPY_LICENSE}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-install
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${PROJECT_BINARY_DIR}/clone
  DEPENDS ${PROJECT_BINARY_DIR}/debug
  DEPENDS ${PROJECT_BINARY_DIR}/release
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-debug
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-release
  VERBATIM)

