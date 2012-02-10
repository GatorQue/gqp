# Filename: CMakeLists.txt
# Description: CMake projects file for building all projects listed in this
#   directory.
# Modification Log:
# 2012-02-03 Initial version
#

# Define our Projects project
project(Projects)

# Use get_subdirs macro to find all subdirectories with a Options.cmake file
get_subdirs(SUBPROJECT_OPTIONS "Options.cmake")

# Now include each Options.cmake file found
set(SUBPROJECT_DEPENDS)
foreach(SUBPROJECT_OPTION_DIR ${SUBPROJECT_OPTIONS})
  include(${SUBPROJECT_OPTION_DIR}/Options.cmake)
endforeach()

# Add projects custom target
add_custom_target(projects ALL DEPENDS ${PROJECT_BINARY_DIR}/projects-complete)

# Add the complete step that depends on the enabled projects added above
add_custom_command(
  OUTPUT ${PROJECT_BINARY_DIR}/projects-complete
  COMMENT "Completed building all projects"
  COMMAND ${CMAKE_COMMAND} -E touch ${PROJECT_BINARY_DIR}/projects-complete
  DEPENDS external
  DEPENDS ${SUBPROJECT_DEPENDS}
  VERBATIM)

# Use get_subdirs macro to find all subdirectories with a CMakeLists.txt files
get_subdirs(SUBPROJECT_CMAKES "CMakeLists.txt")

# Now add each subdirectory found
foreach(SUBPROJECT_CMAKE_DIR ${SUBPROJECT_CMAKES})
  # Get the uppercase version of the subdirectory name
  string(TOUPPER ${SUBPROJECT_CMAKE_DIR} SUBPROJECT_NAME)

  # See if this project is enabled as defined in Options.cmake file in the
  # subdirectory for this project
  if(${${SUBPROJECT_NAME}_ENABLED})
    message(STATUS "Adding project '${SUBPROJECT_CMAKE_DIR}' to build")

    # Create a custom target for this subproject
    add_custom_target(${SUBPROJECT_NAME} ALL
      DEPENDS external
      DEPENDS "${TOUCH_DIR}/${SUBPROJECT_NAME}-complete")

    # Add this subprojects 3rdparty dependencies so they will be built
    foreach(SUBPROJECT_PACKAGE ${${SUBPROJECT_NAME}_3RDPARTY_DEPENDS})
      message(STATUS "${SUBPROJECT_CMAKE_DIR} requires the '${SUBPROJECT_PACKAGE}' 3rdparty/external library")

      # Add the 3rdparty/external libraries this subproject needs
      add_dependencies(${SUBPROJECT_NAME} ${SUBPROJECT_PACKAGE})
    endforeach()

    # Add the complete dependency step command next
    add_custom_command(
      OUTPUT "${TOUCH_DIR}/${SUBPROJECT_NAME}-complete"
      COMMAND ${CMAKE_COMMAND} -E touch "${TOUCH_DIR}/${SUBPROJECT_NAME}-complete"
      WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
      DEPENDS ${PROJECT_BINARY_DIR}/${SUBPROJECT_CMAKE_DIR}
      DEPENDS "${TOUCH_DIR}/${SUBPROJECT_NAME}-build"
      VERBATIM)

    # Add a custom command to create the output directory
    add_custom_command(
      OUTPUT ${PROJECT_BINARY_DIR}/${SUBPROJECT_CMAKE_DIR}
      COMMENT "Creating '${SUBPROJECT_CMAKE_DIR}' build directory"
      COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/${SUBPROJECT_CMAKE_DIR}
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
      VERBATIM)

    # Add a custom command to configure this subproject
    add_custom_command(
      OUTPUT "${TOUCH_DIR}/${SUBPROJECT_NAME}-build"
      COMMENT "Configuring and building the '${SUBPROJECT_CMAKE_DIR}' project"
      COMMAND ${CMAKE_COMMAND}
        ${EXTERNAL_ARGS}
        ${${SUBPROJECT_NAME}_CONFIG_ARGS}
        -DSUBPROJECT_NAME:STRING=${SUBPROJECT_NAME}
        -DTOPLEVEL_DIR:PATH=${CMAKE_SOURCE_DIR}
        -DTOUCH_DIR:PATH=${TOUCH_DIR}
        -DEXTERNAL_DIR:PATH=${EXTERNAL_DIR}
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -G ${CMAKE_GENERATOR} ${PROJECT_SOURCE_DIR}/${SUBPROJECT_CMAKE_DIR}
      COMMAND ${CMAKE_COMMAND}
        --build ${PROJECT_BINARY_DIR}/${SUBPROJECT_CMAKE_DIR}
        --config ${CMAKE_CFG_INTDIR} ${${SUBPROJECT_NAME}_BUILD_ARGS}
      COMMAND ${CMAKE_COMMAND} -E touch "${TOUCH_DIR}/${SUBPROJECT_NAME}-build"
      WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/${SUBPROJECT_CMAKE_DIR}
      DEPENDS ${PROJECT_BINARY_DIR}/${SUBPROJECT_CMAKE_DIR}
      VERBATIM)
  endif(${${SUBPROJECT_NAME}_ENABLED})
endforeach()

