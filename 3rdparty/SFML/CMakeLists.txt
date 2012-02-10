# Filename: CMakeLists.txt
# Description: This will build four versions of the SFML project for each
#   library type you may use (Release, Debug) and (Shared, Static).
# Modification Log:
# 2012-01-03 Initial version
#

# Define the SFML project
project(${EXTERNAL_NAME})

# Define CMake arguments for configuring both versions
set(CONFIG_SFML_DEBUG
  -DBUILD_DOC:BOOL=FALSE
  -DBUILD_EXAMPLES:BOOL=${SFML_BUILD_EXAMPLES}
  -DBUILD_SHARED_LIBS:BOOL=${SFML_SHARED_LIBRARIES}
  -DCMAKE_BUILD_TYPE:STRING=Debug
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
  -G${CMAKE_GENERATOR}
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME})
set(CONFIG_SFML_RELEASE
  -DBUILD_DOC:BOOL=${SFML_BUILD_DOCS}
  -DBUILD_EXAMPLES:BOOL=${SFML_BUILD_EXAMPLES}
  -DBUILD_SHARED_LIBS:BOOL=${SFML_SHARED_LIBRARIES}
  -DCMAKE_BUILD_TYPE:STRING=Release
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
  -G${CMAKE_GENERATOR}
  ${PROJECT_BINARY_DIR}/${PROJECT_NAME})

# Define CMake arguments for building both versions
set(BUILD_SFML_DEBUG
  --build ${PROJECT_BINARY_DIR}/debug
  --config ${CMAKE_CFG_INTDIR})
set(BUILD_SFML_RELEASE
  --build ${PROJECT_BINARY_DIR}/release
  --config ${CMAKE_CFG_INTDIR})

# Define CMake arguments for copying build results to central directory
set(COPY_BIN
    -E copy_directory
    ${PROJECT_BINARY_DIR}/bin
    ${CMAKE_BINARY_DIR}/bin)
set(COPY_LIB
    -E copy_directory
    ${PROJECT_BINARY_DIR}/lib
    ${CMAKE_BINARY_DIR}/lib)
set(COPY_INCLUDE
    -E copy_directory
    ${PROJECT_BINARY_DIR}/include
    ${CMAKE_BINARY_DIR}/include)
set(COPY_DOC
    -E copy_directory
    ${PROJECT_BINARY_DIR}/doc/html
    ${CMAKE_BINARY_DIR}/doc/SFML)
set(COPY_CMAKE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/cmake/Modules
  ${CMAKE_BINARY_DIR}/cmake/Modules)
set(COPY_EXAMPLES
    -E copy_directory
    ${PROJECT_BINARY_DIR}/examples
    ${CMAKE_BINARY_DIR}/examples/SFML)

# Add custom target for this 3rdparty/external library
add_custom_target(${PROJECT_NAME}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-complete)

# Add the complete step first that depends on all the other steps
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-complete
  COMMENT "Completed 'SFML'"
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  DEPENDS ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
  DEPENDS ${PROJECT_BINARY_DIR}/debug
  DEPENDS ${PROJECT_BINARY_DIR}/release
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-debug
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-release
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-install
  VERBATIM)

# Grab the correct 'sfml-get' custom command based on version desired
if(SFML_USE_LATEST)
  # Create Script to clone SFML library
  ScriptCloneGit(${PROJECT_BINARY_DIR}/clone.cmake
    ${SFML_URL}
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
    ${SFML_REVISION_TAG})

  # Add a custom command to clone the GIT repository
  add_custom_command(
    OUTPUT ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
    COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/clone.cmake
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${PROJECT_BINARY_DIR}/debug
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${PROJECT_BINARY_DIR}/release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    VERBATIM)
else(SFML_USE_LATEST)
  # Create Script to download older SFML version source files
  ScriptDownloadFile(${PROJECT_BINARY_DIR}/download.cmake
    ${SFML_URL}
    ${PROJECT_BINARY_DIR}/sfml.zip
    30)

  # Create Script to extract older SFML version source files
  ScriptExtractFile(${PROJECT_BINARY_DIR}/extract.cmake
    ${PROJECT_BINARY_DIR}/sfml.zip
    ${PROJECT_BINARY_DIR}/${PROJECT_NAME})

  # Add a custom command to download and extract older SFML version
  add_custom_command(
    OUTPUT ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
    COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/download.cmake
    COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/extract.cmake
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${PROJECT_BINARY_DIR}/debug
    COMMAND ${CMAKE_COMMAND} -E remove_directory ${PROJECT_BINARY_DIR}/release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
    VERBATIM)
endif(SFML_USE_LATEST)

# Add a custom command to create the debug library build folder
add_custom_command(
  OUTPUT ${PROJECT_BINARY_DIR}/debug
  COMMENT "Making 'SFML' debug build directory"
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/debug
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
  VERBATIM)

# Build a debug build of the library
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-debug
  COMMENT "Configuring 'SFML' for debug libraries"
  COMMAND ${CMAKE_COMMAND} ${CONFIG_SFML_DEBUG}
  COMMAND ${CMAKE_COMMAND} ${BUILD_SFML_DEBUG} --target install
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-debug
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/debug
  DEPENDS ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
  DEPENDS ${PROJECT_BINARY_DIR}/debug
  VERBATIM)

# Add a custom command to create the release library build folder
add_custom_command(
  OUTPUT ${PROJECT_BINARY_DIR}/release
  COMMENT "Making 'SFML' release build directory"
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/release
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
  VERBATIM)

# Build a release build of the library
if(SFML_BUILD_DOCS)
  add_custom_command(
    OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-release
    COMMENT "Configuring 'SFML' for release libraries"
    COMMAND ${CMAKE_COMMAND} ${CONFIG_SFML_RELEASE}
    COMMAND ${CMAKE_COMMAND} ${BUILD_SFML_RELEASE} --target doc
    COMMAND ${CMAKE_COMMAND} ${BUILD_SFML_RELEASE} --target install
    COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/release
    DEPENDS ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
    DEPENDS ${PROJECT_BINARY_DIR}/release
    VERBATIM)
else(SFML_BUILD_DOCS)
  add_custom_command(
    OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-release
    COMMENT "Configuring 'SFML' for release libraries"
    COMMAND ${CMAKE_COMMAND} ${CONFIG_SFML_RELEASE}
    COMMAND ${CMAKE_COMMAND} ${BUILD_SFML_RELEASE} --target install
    COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/release
    DEPENDS ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
    DEPENDS ${PROJECT_BINARY_DIR}/release
    VERBATIM)
endif(SFML_BUILD_DOCS)

# Install the compiled libraries, binary files, include files, and documents
# to the correct folders for GQE to find them.
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-install
  COMMENT "Installing 'SFML' libraries into build root"
  COMMAND ${CMAKE_COMMAND} ${COPY_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_EXAMPLES}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-install
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${PROJECT_BINARY_DIR}/${PROJECT_NAME}
  DEPENDS ${PROJECT_BINARY_DIR}/debug
  DEPENDS ${PROJECT_BINARY_DIR}/release
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-debug
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-release
  VERBATIM)

