# Filename: CMakeLists.txt
# Description: CMake projects file for building all projects listed in this
#   directory.
# Modification Log:
# 2012-02-03 Initial version
# 2012-02-11 Add CMAKE modules directory for configure
# 2012-03-23 Simplify the handling of subproject folders
#

# Define our Projects project
project(Projects)

# Use get_subdirs macro to find all subdirectories with a Options.cmake file
get_subdirs(SUBPROJECT_OPTIONS "Options.cmake")

# Now include each Options.cmake file found
foreach(SUBPROJECT_OPTION_DIR ${SUBPROJECT_OPTIONS})
  include(${SUBPROJECT_OPTION_DIR}/Options.cmake)
endforeach()

# Use get_subdirs macro to find all subdirectories with a CMakeLists.txt files
get_subdirs(SUBPROJECT_CMAKES "CMakeLists.txt")

# Now add each subdirectory found
foreach(SUBPROJECT_CMAKE_DIR ${SUBPROJECT_CMAKES})
  # Get the uppercase version of the subdirectory name
  string(TOUPPER ${SUBPROJECT_CMAKE_DIR} SUBPROJECT_NAME)

  # See if this project is enabled as defined in Options.cmake file in the
  # subdirectory for this project
  if(${${SUBPROJECT_NAME}_ENABLED})
    # Add this projects subdirectory to the build
    add_subdirectory(${SUBPROJECT_CMAKE_DIR})
  endif(${${SUBPROJECT_NAME}_ENABLED})
endforeach()

