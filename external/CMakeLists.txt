# Filename: CMakeLists.txt
# Description: CMake file for adding each external 3rd party project to the
#   build chain.
# Modification Log:
# 2012-02-04 Initial version
# 2012-02-11 Remove extra copy step, less duplication of files
# 2012-03-23 Move to new directory and simplify handling of external projects
# 2012-04-03 Fix case sensitive module name issues
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

# Use get_subdirs macro to find all subdirectories with a CMakeLists.txt files
get_subdirs(EXTERNAL_CMAKES "CMakeLists.txt")

# Now add each subdirectory found
foreach(EXTERNAL_CMAKE_DIR ${EXTERNAL_CMAKES})
  # Get the uppercase version of the subdirectory name
  string(TOUPPER ${EXTERNAL_CMAKE_DIR} EXTERNAL_NAME)

  # First see if this module is enabled
  if(${${EXTERNAL_NAME}_ENABLED})
    # Now see if a prebuilt version already exists
    find_package(${EXTERNAL_CMAKE_DIR} COMPONENTS ${${EXTERNAL_NAME}_COMPONENTS})

    # Force local module or local module the only one found?
    if(NOT USE_PRECOMPILED_EXTERNAL OR ${EXTERNAL_NAME}_LOCAL)
      # Add the subdirectory target if enabled
      add_subdirectory(${EXTERNAL_CMAKE_DIR})

      # Parse this modules library dependencies
      parse_arguments(THIS "${${EXTERNAL_NAME}_DEPS}" "" ${${EXTERNAL_NAME}_LIB_DEPS})

      # Loop through each library this module provides
      foreach(MODULE_NAME ${${EXTERNAL_NAME}_LIBS})
        # Loop through each dependency
        foreach(MODULE_EXTERNAL_NAME ${${EXTERNAL_NAME}_DEPS})
          # Loop through each dependent library for this module
          foreach(LIBRARY_TARGET_NAME ${THIS_${MODULE_EXTERNAL_NAME}})
            # Add a dependency for this library to our library
            add_dependencies(${MODULE_NAME} ${LIBRARY_TARGET_NAME})
          endforeach()
        endforeach()
      endforeach()
    endif(NOT USE_PRECOMPILED_EXTERNAL OR ${EXTERNAL_NAME}_LOCAL)
  endif(${${EXTERNAL_NAME}_ENABLED})
endforeach(EXTERNAL_CMAKE_DIR ${EXTERNAL_CMAKES})

