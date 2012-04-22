# The module defines the following variables:
#   MERCURIAL_EXECUTABLE - path to hg command line client
#   MERCURIAL_FOUND - true if the command line client was found
# Example usage:
#   find_package(Mercurial)
#   if(MERCURIAL_FOUND)
#     message("hg found: ${MERCURIAL_EXECUTABLE}")
#   endif()

# Look for 'hg'
#
set(mercurial_names hg)

find_program(MERCURIAL_EXECUTABLE
  NAMES ${mercurial_names}
  DOC "mercurial command line client"
  )
mark_as_advanced(MERCURIAL_EXECUTABLE)

# Handle the QUIETLY and REQUIRED arguments and set MERCURIAL_FOUND to TRUE if
# all listed variables are TRUE
include(${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(Mercurial DEFAULT_MSG MERCURIAL_EXECUTABLE)
