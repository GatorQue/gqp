# Filename: Macros.cmake
# Description: Useful macros for building external libraries and sources.
# Modification Log:
# 2012-01-02 Initial version
# 2014-10-08 Add get_add_list_by_dependency macro for better module checking.
#

# Name: get_subdirs
# Description: Scan and return all subdirectories that contain the filename
# specified.
# Usage: get_subdirs(list_returned_here filename-to-find)
# Example: get_subdirs(dir-list "CMakeLists.txt")
macro(get_subdirs retval filename)
  # Search from current directory for filename specified
  file(GLOB file-list RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} */${filename})

  # Return relative path to each directory found
  set(dir-list "")
  foreach(item ${file-list})
    get_filename_component(file-path ${item} PATH)
    set(dir-list ${dir-list} ${file-path})
  endforeach()
  set(${retval} ${dir-list})
endmacro(get_subdirs)



# Name: get_add_list_by_dependency
# Description: Retrieve a list of external modules to include based on
# dependency order.
# Usage: get_add_list_by_dependency(list_returned_here external_dir)
# Example: get_add_list_by_dependency(external-dir-list ${EXTERNAL_CMAKE_DIR})
macro(get_add_list_by_dependency retval)
  # Use get_subdirs macro to find all subdirectories with a CMakeLists.txt files
  get_subdirs(CMAKE_LISTS "CMakeLists.txt")

  # Return relative path to each directory found
  set(add-list "")

  # Now add each subdirectory found
  foreach(CMAKE_LIST_DIR ${CMAKE_LISTS})
    # Get the uppercase version of the subdirectory name
    string(TOUPPER ${CMAKE_LIST_DIR} CMAKE_LIST_NAME)

    # First see if this module is enabled and not already added
    if(${${CMAKE_LIST_NAME}_ENABLED})
      # Now see if a prebuilt version already exists
      find_package(${CMAKE_LIST_DIR} COMPONENTS ${${CMAKE_LIST_NAME}_COMPONENTS})

      # Force local module or local module the only one found?
      if(NOT USE_PRECOMPILED_EXTERNAL OR ${CMAKE_LIST_NAME}_LOCAL)
        # Parse this modules library dependencies
        parse_arguments(THIS "${${CMAKE_LIST_NAME}_DEPS}" "" ${${CMAKE_LIST_NAME}_LIB_DEPS})

        # Loop through each dependency
        foreach(DEP_DIR ${${CMAKE_LIST_NAME}_DEPS})
          # Get the uppercase version of the dependency directory name
          string(TOUPPER ${DEP_DIR} DEP_NAME)

          # See if a prebuilt version already exists for dependency
          find_package(${DEP_DIR} COMPONENTS ${${DEP_NAME}_COMPONENTS})
          
          # Force local module or local module the only one found?
          if(NOT USE_PRECOMPILED_EXTERNAL OR ${DEP_NAME}_LOCAL)
            # Add dependencies to front of list
            set(add-list ${DEP_DIR} ${add-list})
          endif(NOT USE_PRECOMPILED_EXTERNAL OR ${DEP_NAME}_LOCAL)
        endforeach()
        
        # Add this module to the back of the list
        set(add-list ${add-list} ${CMAKE_LIST_DIR})
      endif(NOT USE_PRECOMPILED_EXTERNAL OR ${CMAKE_LIST_NAME}_LOCAL)
    endif(${${CMAKE_LIST_NAME}_ENABLED})
    # Remove duplicates
    list(REMOVE_DUPLICATES add-list)
    # Set return result from list above
    set(${retval} ${add-list})
  endforeach(CMAKE_LIST_DIR ${CMAKE_LISTS})

endmacro(get_add_list_by_dependency retval)

# Name: set_option
# Description: Set the CMAKE option to default if not found or to the value
# specified.
# Usage: set_option(var default type docstring)
# Example: set_option(TARGET_HOST_TYPE "x86" String "x64")
macro(set_option var default type docstring)
  if(NOT DEFINED ${var})
    set(${var} ${default})
  endif()
  set(${var} ${${var}} CACHE ${type} ${docstring} FORCE)
endmacro(set_option)

# Name: list_contains
# Description: Check if a value is contained in a list and sets ${var} to TRUE
# if the value is found
# Usage: list_contains(VAR VALUE)
# Example: list_contains(is_arg_name ${ARG} ${ARG_NAMES})
macro(list_contains var value)
  set(${var})
  foreach(value2 ${ARGN})
    if(${value} STREQUAL ${value2})
      set(${var} TRUE)
    endif()
  endforeach()
endmacro(list_contains)

# Name: parse_arguments
# Description: Parse a list of arguments and options
# Usage: parse_arguments(prefix arg_names option_names)
# Example: parse_arguments(THIS "SOURCES;DEPENDS" "FLAG" FLAG
#   SOURCES s1 s2 s3
#   DEPENDS d1 d2)
# which will define the following variables:
# - THIS_SOURCES (s1 s2 s3)
# - THIS_DEPENDS (d1 d2)
# - THIS_FLAG TRUE
macro(parse_arguments prefix arg_names option_names)
  foreach(arg_name ${arg_names})
    set(${prefix}_${arg_name})
  endforeach()
  foreach(option_name ${option_names})
    set(${prefix}_${option_name} FALSE)
  endforeach()
  set(current_arg_name)
  set(current_arg_list)
  foreach(arg ${ARGN})
    list_contains(is_arg_name ${arg} ${arg_names})
    if(is_arg_name)
      set(${prefix}_${current_arg_name} ${current_arg_list})
      set(current_arg_name ${arg})
      set(current_arg_list)
    else()
      list_contains(is_option ${arg} ${option_names})
      if(is_option)
        set(${prefix}_${arg} TRUE)
      else()
        set(current_arg_list ${current_arg_list} ${arg})
      endif()
    endif()
  endforeach()
  set(${prefix}_${current_arg_name} ${current_arg_list})
endmacro(parse_arguments)

# Name: add_project
# Description: Add a new target(s) for the project specified
# Usage: add_project(TicTacToe
#                    SOURCES main.cpp ...
#                    DEPENDS gqe-core)
# Example: add_project(${PROJECT_NAME}
#                      SOURCES ${${PROJECT_NAME}_SOURCES}
#                      DEPENDS ${${PROJECT_NAME}_DEPENDS}
macro(add_project target)
  # parse the arguments
  parse_arguments(THIS "SOURCES;DEPENDS" "" ${ARGN})

  # Add the target specified and its source files
  add_executable(${target} ${THIS_SOURCES})

  # set the debug suffix
  set_target_properties(${target} PROPERTIES DEBUG_POSTFIX -d)

  # for gcc 4.x on Windows, apply the BUILD_STATIC_STD_LIBS option if it is enabled
  if(WINDOWS AND COMPILER_GCC AND BUILD_STATIC_STD_LIBS)
    if(${GCC_VERSION} MATCHES "4\\..*")
      set_target_properties(${target} PROPERTIES LINK_FLAGS "-static-libgcc -static-libstdc++")
    endif()
  endif()

  # link the target to its dependencies
  if(THIS_DEPENDS)
    target_link_libraries(${target} ${THIS_DEPENDS})
  endif()

  # TODO: Copy DLL files from external to build directory after build

  # Copy resources folder to build directory after build
  add_custom_command(TARGET ${target}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${PROJECT_SOURCE_DIR}/resources
    ${PROJECT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/resources)

  # TODO: Add the install rule
  #install(TARGETS ${target}
  #  RUNTIME DESTINATION ${INSTALL_DATA_DIR} COMPONENT binaries)

  # TODO: Add the install rule for the resources folder if it exists
  #set(RESOURCES "${PROJECT_SOURCE_DIR}/resources")
  #if(EXISTS ${RESOURCES})
  #  install(DIRECTORY ${RESOURCES}
  #          DESTINATION ${INSTALL_DATA_DIR}
  #          COMPONENT binaries)
  #endif()
endmacro(add_project)
