# Filename: CMakeLists.txt
# Description: CMake file for adding each external 3rd party project to the
#   build chain.
# Modification Log:
# 2012-02-04 Initial version
# 2012-02-11 Remove extra copy step, less duplication of files
# 2012-03-23 Move to new directory and simplify handling of external projects
# 2012-04-03 Fix case sensitive module name issues
# 2014-10-08 Fix external module checking for better dependency support
#

# Create a project name for the external 3rd party project files
project(external)

# Create our fake FindXYZ modules directory if it doesn't already exist yet
file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/Modules)

# Use get_subdirs macro to find all subdirectories with a Options.cmake file
get_subdirs(EXTERNAL_OPTIONS "Options.cmake")

# Now include each Options.cmake file found
foreach(EXTERNAL_OPTION_DIR ${EXTERNAL_OPTIONS})
  # Get the uppercase version of the subdirectory name
  string(TOUPPER ${EXTERNAL_OPTION_DIR} EXTERNAL_NAME)

  # Include our Options.cmake file for this 3rdparty/external module
  include(${EXTERNAL_OPTION_DIR}/Options.cmake)
endforeach()

get_add_list_by_dependency(EXTERNAL_LIST)

# Now include each Options.cmake file found
foreach(EXTERNAL_CMAKE_DIR ${EXTERNAL_LIST})
  message(STATUS "Adding external library '${EXTERNAL_CMAKE_DIR}'")

  # Add the subdirectory target
  add_subdirectory(${EXTERNAL_CMAKE_DIR})

  # Get the uppercase version of the subdirectory name
  string(TOUPPER ${EXTERNAL_CMAKE_DIR} EXTERNAL_NAME)

  # Parse this modules library dependencies
  parse_arguments(THIS "${${EXTERNAL_NAME}_DEPS}" "" ${${EXTERNAL_NAME}_LIB_DEPS})

  # Loop through each library this module provides
  foreach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})
    # Loop through each dependency
    foreach(MODULE_EXTERNAL_NAME ${${EXTERNAL_NAME}_DEPS})
      # Is this dependency a locally provided target?
      string(TOUPPER ${MODULE_EXTERNAL_NAME} DEP_NAME)
      if(NOT USE_PRECOMPILED_EXTERNAL OR ${DEP_NAME}_LOCAL)
        # Loop through each dependent library for this module
        foreach(LIBRARY_TARGET_NAME ${THIS_${MODULE_EXTERNAL_NAME}})
          # Add a dependency for this library to our library
          add_dependencies(${MODULE_NAME} ${LIBRARY_TARGET_NAME})
        endforeach(LIBRARY_TARGET_NAME ${THIS_${MODULE_EXTERNAL_NAME}})
      endif(NOT USE_PRECOMPILED_EXTERNAL OR ${DEP_NAME}_LOCAL)
    endforeach(MODULE_EXTERNAL_NAME ${${EXTERNAL_NAME}_DEPS})
  endforeach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})
endforeach()
