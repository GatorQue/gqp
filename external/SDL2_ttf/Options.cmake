# Filename: Options.cmake
# Description: Define the SDL2_ttf external 3rd party library options used in
#   the CMakeList.txt file.
# Modification Log:
# 2014-10-03 Initial version
#

# SDL2_ttf library options
set_option(SDL2_TTF_ENABLED TRUE BOOL "Build 'SDL2_ttf' 3rdparty/external libraries?")
# SDL2_ttf doesn't yet support shared libraries
set_option(SDL2_TTF_SHARED_LIBRARIES FALSE BOOL "Build 'SDL2_ttf' shared libraries?")
# SDL2_ttf comes with a pre-built API reference in HTML format
set_option(SDL2_TTF_BUILD_DOCS FALSE BOOL "Build 'SDL2_ttf' documentation?")
# SDL2_ttf examples are separate from the source code
set_option(SDL2_TTF_BUILD_EXAMPLES FALSE BOOL "Build 'SDL2_ttf' examples?")
set_option(SDL2_TTF_URL
  "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.zip"
  STRING
  "URL for getting latest 'SDL2_ttf' version")

# Create a list of libraries provided by this 3rd party/external module
set(SDL2_TTF_LIBS SDL2_ttf)
# Push the list to the parent scope for projects to reference
set(SDL2_TTF_LIBS ${SDL2_TTF_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(SDL2_TTF_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(SDL2_TTF_COMPONENTS ${SDL2_TTF_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
set(SDL2_TTF_DEFS)
# Push the list to the parent scope for projects to reference
set(SDL2_TTF_DEFS ${SDL2_TTF_DEFS} PARENT_SCOPE)

# Create a list of examples
set(SDL2_TTF_EXAMPLES)

# Create a list of external dependencies used by this external library
set(SDL2_TTF_DEPS Freetype SDL2)
# Push the list to the parent scope for projects to reference
set(SDL2_TTF_DEPS ${SDL2_TTF_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(SDL2_TTF_LIB_DEPS
  Freetype freetype
  SDL2 SDL2 SDL2main)
# Push the list to the parent scope for projects to reference
set(SDL2_TTF_LIB_DEPS ${SDL2_TTF_LIB_DEPS} PARENT_SCOPE)

# Add internal options if SDL2_ttf is enabled
if(SDL2_TTF_ENABLED)
  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES SDL2_ttf)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR}/include/SDL2)

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(SDL2_TTF_DIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(SDL2_TTF_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(SDL2_TTF_BIN_DIR ${SDL2_TTF_BIN_DIR} PARENT_SCOPE)
endif(SDL2_TTF_ENABLED)

