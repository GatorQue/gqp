# Filename: Options.cmake
# Description: Define the GQE external 3rd party library options used in the
#   CMakeList.txt file.
# Modification Log:
# 2012-01-13 Initial version
#

# GQE library options
set_option(GQE_ENABLED TRUE BOOL "Build 'GQE' 3rdparty/external libraries?")
set_option(GQE_SHARED_LIBRARIES TRUE BOOL "Build 'GQE' shared libraries?")
set_option(GQE_REVISION_TAG "" STRING "Which 'GQE' revision/tag to use?")
set_option(GQE_BUILD_DOCS FALSE BOOL "Build 'GQE' documentation?")
set_option(GQE_BUILD_EXAMPLES FALSE BOOL "Build 'GQE' examples?")
set_option(GQE_URL
  "https://RyanLindeman@code.google.com/p/gqe"
  STRING
  "Mercurial URL to obtain latest 'GQE' version")

# Create a list of libraries provided by this external module
set(GQE_LIBS gqe-core gqe-entity)
# Push the list to the parent scope for projects to reference
set(GQE_LIBS ${GQE_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(GQE_COMPONENTS CORE ENTITY)
# Push this list to the parent scope for projects to reference
set(GQE_COMPONENTS ${GQE_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
if(GQE_SHARED_LIBRARIES)
  set(GQE_DEFS -DGQE_DYNAMIC)
else(GQE_SHARED_LIBRARIES)
  set(GQE_DEFS -DGQE_STATIC)
  set(GQE_STATIC_LIBRARIES TRUE)
endif(GQE_SHARED_LIBRARIES)
# Push the list to the parent scope for projects to reference
set(GQE_DEFS ${GQE_DEFS} PARENT_SCOPE)

# Create a list of example targets provided by this library
set(GQE_EXAMPLES spacedots tictactoe)

# Create a list of external dependencies used by this external library
set(GQE_DEPS SFML)
# Push the list to the parent scope for projects to reference
set(GQE_DEPS ${GQE_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
if(WINDOWS)
  set(GQE_LIB_DEPS
    SFML sfml-audio sfml-graphics sfml-window sfml-network sfml-system sfml-main)
else(WINDOWS)
  set(GQE_LIB_DEPS
    SFML sfml-audio sfml-graphics sfml-window sfml-network sfml-system)
endif(WINDOWS)
# Push the list to the parent scope for projects to reference
set(GQE_LIB_DEPS ${GQE_LIB_DEPS} PARENT_SCOPE)

# Add internal options if GQE is enabled
if(GQE_ENABLED)
  # Define the libraries produced by this external module
  set(FIND_CORE_LIBRARY gqe-core)
  set(FIND_ENTITY_LIBRARY gqe-entity)

  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES
    ${FIND_CORE_LIBRARY}
    ${FIND_ENTITY_LIBRARY})

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/include)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(GQEDIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(GQE_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(GQE_BIN_DIR ${GQE_BIN_DIR} PARENT_SCOPE)
endif(GQE_ENABLED)

