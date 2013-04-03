# Filename: Options.cmake
# Description: Define the Lua external 3rd party library options used in
#   the CMakeList.txt file.
# Modification Log:
# 2013-04-01 Initial version
#

# LUA library options
set_option(LUA_ENABLED TRUE BOOL "Build 'Lua' 3rdparty/external libraries?")
set_option(LUA_SHARED_LIBRARIES TRUE BOOL "Build 'Lua' shared libraries?")
set_option(LUA_BUILD_DOCS FALSE BOOL "Build 'Lua' documentation?")
# LUA doesn't provide examples
set_option(LUA_BUILD_EXAMPLES FALSE BOOL "Build 'Lua' examples?")

# Determine which URL to use to obtain the LUA source files
set_option(LUA_URL
  "http://www.lua.org/ftp/lua-5.2.2.tar.gz"
  STRING
  "URL for getting latest 'Lua' version")

# Create a list of examples
set(LUA_EXAMPLES)

# Create a list of libraries provided by this 3rd party/external module
set(LUA_LIBS lua)
# Push the list to the parent scope for projects to reference
set(LUA_LIBS ${LUA_LIBS} PARENT_SCOPE)

# Create a list of components provided by this external module
set(LUA_COMPONENTS)
# Push this list to the parent scope for projects to reference
set(LUA_COMPONENTS ${LUA_COMPONENTS} PARENT_SCOPE)

# Create a list of definitions for projects to use
if(LUA_SHARED_LIBRARIES)
  set(LUA_DEFS -DLUA_BUILD_AS_DLL)
else(LUA_SHARED_LIBRARIES)
  set(LUA_DEFS)
endif(LUA_SHARED_LIBRARIES)
# Push the list to the parent scope for projects to reference
set(LUA_DEFS ${LUA_DEFS} PARENT_SCOPE)

# Create a list of external dependencies used by this external library
set(LUA_DEPS)
# Push the list to the parent scope for projects to reference
set(LUA_DEPS ${LUA_DEPS} PARENT_SCOPE)

# Create a list of external library dependencies used by this external library
set(LUA_LIB_DEPS)
# Push the list to the parent scope for projects to reference
set(LUA_LIB_DEPS ${LUA_LIB_DEPS} PARENT_SCOPE)

# Add internal options if LUA is enabled
if(LUA_ENABLED)
  # Define the libraries produced by this external module

  # Define the global list of libraries produced by this external module
  set(FIND_LIBRARIES lua)

  # Define the include directory to reference for this external module
  set(FIND_INCLUDE_DIR
    ${TOPLEVEL_DIR}/${EXTERNAL_OPTION_DIR})

  # Define the definitions that should used with this library
  set(FIND_DEFS ${LUA_DEFS})

  # Create the Find.cmake module for this external module
  configure_file(${PROJECT_SOURCE_DIR}/${EXTERNAL_OPTION_DIR}/FindModule.in
    ${CMAKE_BINARY_DIR}/Modules/Find${EXTERNAL_OPTION_DIR}.cmake
    @ONLY)

  # Define where this module can find the precompiled libraries
  set(LUADIR ${EXTERNAL_DIR})

  # Specify the binary directory to copy as a post_build step
  set(LUA_BIN_DIR
    ${EXTERNAL_BIN_DIR})
  # Push the list to the parent scope for projects to reference
  set(LUA_BIN_DIR ${LUA_BIN_DIR} PARENT_SCOPE)
endif(LUA_ENABLED)

