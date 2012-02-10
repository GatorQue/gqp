# Filename: CMakeLists.txt
# Description: This will install the GQE source and include files into the
#   external library for you to reference.
# Modification Log:
# 2012-01-13 Initial version
#

# Define the GQE project
project(${EXTERNAL_NAME})

# Create the SFML_STATIC_LIBRARIES variable for our use below
if(SFML_SHARED_LIBRARIES)
  set(SFML_STATIC_LIBRARIES FALSE)
else(SFML_SHARED_LIBRARIES)
  set(SFML_STATIC_LIBRARIES TRUE)
endif(SFML_SHARED_LIBRARIES)

# Define CMake arguments for configuring both versions
set(CLONE_DIR ${PROJECT_BINARY_DIR}/gqe)
set(CONFIG_GQE_DEBUG
  -DINSTALL_DOC:BOOL=false
  -DBUILD_EXAMPLES:BOOL=${GQE_BUILD_EXAMPLES}
  -DBUILD_SHARED_LIBS:BOOL=${GQE_SHARED_LIBRARIES}
  -DSFML_STATIC_LIBRARIES:BOOL=${SFML_STATIC_LIBRARIES}
  -DSFMLDIR:PATH=${CMAKE_BINARY_DIR}
  -DCMAKE_BUILD_TYPE:STRING=Debug
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
  -G${CMAKE_GENERATOR}
  ${CLONE_DIR})
set(CONFIG_GQE_RELEASE
  -DINSTALL_DOC:BOOL=${GQE_BUILD_DOCS}
  -DBUILD_EXAMPLES:BOOL=${GQE_BUILD_EXAMPLES}
  -DBUILD_SHARED_LIBS:BOOL=${GQE_SHARED_LIBRARIES}
  -DSFML_STATIC_LIBRARIES:BOOL=${SFML_STATIC_LIBRARIES}
  -DSFMLDIR:PATH=${CMAKE_BINARY_DIR}
  -DCMAKE_BUILD_TYPE:STRING=Release
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}
  -G${CMAKE_GENERATOR}
  ${CLONE_DIR})

# Define CMake arguments for copying building both versions
set(BUILD_GQE_DEBUG
  --build ${PROJECT_BINARY_DIR}/debug
  --config ${CMAKE_CFG_INTDIR})
set(BUILD_GQE_RELEASE
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
  ${CMAKE_BINARY_DIR}/doc/GQE)
set(COPY_CMAKE
  -E copy_directory
  ${PROJECT_BINARY_DIR}/cmake/Modules
  ${CMAKE_BINARY_DIR}/cmake/Modules)
set(COPY_EXAMPLES
  -E copy_directory
  ${PROJECT_BINARY_DIR}/examples
  ${CMAKE_BINARY_DIR}/examples/GQE)

# Create Script to clone GQE library
ScriptCloneMercurial(${PROJECT_BINARY_DIR}/clone.cmake
  "https://RyanLindeman@code.google.com/p/gqe"
  ${CLONE_DIR}
  ${GQE_REVISION_TAG})

# Add custom target for this 3rdparty/external library
add_custom_target(${PROJECT_NAME}
  DEPENDS SFML
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-complete)

# Add the complete step first that depends on all the other steps
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-complete
  COMMENT "Completed getting, building, and installing 'GQE'"
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-complete
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-clone
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-debug
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-release
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-install
  VERBATIM)

# Add a custom command to create the library build folders
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  COMMENT "Making 'GQE' build directories"
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/debug
  COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/release
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  VERBATIM)

# Add a custom command to download the Mercurial repository
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-clone
  COMMAND ${CMAKE_COMMAND} -P ${PROJECT_BINARY_DIR}/clone.cmake
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-clone
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  VERBATIM)

# Build a debug build of the library
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-debug
  COMMENT "Configuring 'GQE' for debug libraries"
  COMMAND ${CMAKE_COMMAND} ${CONFIG_GQE_DEBUG}
  COMMAND ${CMAKE_COMMAND} ${BUILD_GQE_DEBUG} --target install
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-debug
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/debug
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-clone
  VERBATIM)

# Build a release build of the library
if(GQE_BUILD_DOCS)
  add_custom_command(
    OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-release
    COMMENT "Configuring 'GQE' for release libraries"
    COMMAND ${CMAKE_COMMAND} ${CONFIG_GQE_RELEASE}
    COMMAND ${CMAKE_COMMAND} ${BUILD_GQE_RELEASE} --target doc
    COMMAND ${CMAKE_COMMAND} ${BUILD_GQE_RELEASE} --target install
    COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/release
    DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
    DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-clone
    VERBATIM)
else(GQE_BUILD_DOCS)
  add_custom_command(
    OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-release
    COMMENT "Configuring 'GQE' for release libraries"
    COMMAND ${CMAKE_COMMAND} ${CONFIG_GQE_RELEASE}
    COMMAND ${CMAKE_COMMAND} ${BUILD_GQE_RELEASE} --target install
    COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-release
    WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/release
    DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
    DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-clone
    VERBATIM)
endif(GQE_BUILD_DOCS)

# Install the include files, documentation, and source files to the external
# folder for use my our projects.
add_custom_command(
  OUTPUT ${TOUCH_DIR}/${PROJECT_NAME}-install
  COMMENT "Installing 'GQE' libraries into build root"
  COMMAND ${CMAKE_COMMAND} ${COPY_BIN}
  COMMAND ${CMAKE_COMMAND} ${COPY_LIB}
  COMMAND ${CMAKE_COMMAND} ${COPY_INCLUDE}
  COMMAND ${CMAKE_COMMAND} ${COPY_DOC}
  COMMAND ${CMAKE_COMMAND} ${COPY_CMAKE}
  COMMAND ${CMAKE_COMMAND} ${COPY_EXAMPLES}
  COMMAND ${CMAKE_COMMAND} -E touch ${TOUCH_DIR}/${PROJECT_NAME}-install
  WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-mkdir
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-clone
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-debug
  DEPENDS ${TOUCH_DIR}/${PROJECT_NAME}-release
  VERBATIM)

