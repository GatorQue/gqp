# Filename: Scripts.cmake
# Description: Useful functions for creating scripts that can be used to
# clone, extract, and/or download files from the internet
# Modification Log:
# 2012-01-28 Initial version
# 2012-02-11 Fix type in ScriptCloneSubversion function
# 2012-03-23 Fixes to a few update/clone functions and added CopyBinaries script
#

# Name: ScriptCopyBinaries
# Description: Write a copy script to copy all binary files specified to the
# directory specified.
# Usage: ScriptCopyBinaries(script_filename directory files)
# Example:
# ScriptCopyBinaries(${PROJECT_BINARY_DIR}/copy.cmake ${PROJECT_BINARY_DIR}/${CMAKE_CFG_INTDIR} ${RELASE_BINARIES} ${DEBUG_BINARIES})
function(ScriptCopyBinaries script_filename destination)
  # Erase the script_filename if it already exists
  file(REMOVE ${script_filename})

  # Loop through optional arguments
  foreach(src_file ${ARGN})
    file(APPEND ${script_filename} "
if(EXISTS \"${src_file}\")
  message(STATUS \"Copying '${src_file}' to '${destination}'\")
  file(COPY \"${src_file}\" DESTINATION \"${destination}\")
endif(EXISTS \"${src_file}\")
")
  endforeach(src_file ${ARGN})
endfunction(ScriptCopyBinaries)

# Name: ScriptDownloadFile
# Description: Write a download script to download the file specified within
# the timeout specified with an inactivity timeout specified. If an MD5 sum is
# available it can be used to verify the download when it completes.
# Usage: ScriptDownloadFile(script_filename remote local [inactivity] [md5] [timeout])
# Example:
# ScriptDownloadFile(${PROJECT_BINARY_DIR}/download.cmake
#   http://code.google.com/p/gqe/gqe-core.zip
#   ${PROJECT_BINARY_DIR}/gqe-core.zip
#   30)
function(ScriptDownloadFile script_filename remote local)
  # Check for optional inactivity timeout argument
  if(ARGV3)
    set(inactivity_args INACTIVITY_TIMEOUT ${ARGV3})
    set(inactivity_msg "Inactivity timeout ${ARGV3} seconds")
  else(ARGV3)
    set(inactivity_args "# no INACITIVITY_TIMEOUT")
    set(inactivity_msg "none")
  endif(ARGV3)

  # Check for optional md5 argument
  if(ARGV4)
    set(md5_args EXPECTED_MD5 ${ARGV4})
  else(ARGV4)
    set(md5_args "# no EXPECTED_MD5")
  endif(ARGV4)

  # Check for optional timeout argument
  if(ARGV5)
    set(timeout_args TIMEOUT ${ARGV5})
    set(timeout_msg "Timeout ${ARGV5} seconds")
  else(ARGV5)
    set(timeout_args "# no TIMEOUT")
    set(timeout_msg "none")
  endif(ARGV5)

  # Now write the script file
  file(WRITE ${script_filename} "
message(STATUS \"downloading...
  src='${remote}'
  dst='${local}'
  inactivity='${inactivity_msg}'
  timeout='${timeout_msg}'\")

file(DOWNLOAD
  \"${remote}\"
  \"${local}\"
  SHOW_PROGRESS
  ${inactivity_args}
  ${timeout_args}
  ${md5_args}
  STATUS status
  LOG log)

list(GET status 0 status_code)
list(GET status 1 status_string)

if(NOT status_code EQUAL 0)
  message(FATAL_ERROR \"error: downloading '${remote}' failed
    status_code: \${status_code}
    status_string: \${status_string}
    log: \${log}\")
endif()

message(STATUS \"downloading... done\")
")
endfunction(ScriptDownloadFile)

# Name: ScriptExtractFile
# Description: Write an extract script to extract the file that was downloaded
# to the directory specified.
# Usage: ScriptExtractFile(script_filename filename directory)
# Example:
# ScriptExtractFile(${PROJECT_BINARY_DIR}/extract.cmake
#   ${PROJECT_BINARY_DIR}/gqe-core.zip
#   ${PROJECT_BINARY_DIR}/gqe-core)
function(ScriptExtractFile script_filename filename directory)
  # Clear tar_args value
  set(tar_args "")

  # See if filename is of type .bz2, .tar.gz, .tgz, or .zip
  if(filename MATCHES "(\\.|=)(bz2|tar\\.gz|tgz|zip)$")
    set(tar_args xfz)
  endif()

  # See if filename is of type .tar
  if(filename MATCHES "(\\.|=)tar$")
    set(tar_args xf)
  endif()

  if(tar_args STREQUAL "")
    message(SEND_ERROR "error: do not know how to extract '${filename}' -- known types are .bz2, .tar, .tar.gz, .tgz, and .zip")
    return()
  endif()

  file(WRITE ${script_filename} "
# Make file names absolute
get_filename_component(filename \"${filename}\" ABSOLUTE)
get_filename_component(directory \"${directory}\" ABSOLUTE)

message(STATUS \"extracting...
  src='\${filename}'
  dst='\${directory}'\")

if(NOT EXISTS \"\${filename}\")
  message(FATAL_ERROR \"error: file to extract does not exist: '\${filename}'\")
endif()

# Prepare a space for extracting:
set(i 1234)
while(EXISTS \"\${directory}/../ex-${name}\${i}\")
  math(EXPR i \"\${i} + 1\")
endwhile()
set(ut_dir \"\${directory}/../ex-${name}\${i}\")
file(MAKE_DIRECTORY \"\${ut_dir}\")

# Extract it:
message(STATUS \"extracting... [tar ${tar_args}]\")
execute_process(COMMAND \${CMAKE_COMMAND} -E tar ${tar_args} \${filename}
  WORKING_DIRECTORY \${ut_dir}
  RESULT_VARIABLE error_code)

if(NOT error_code EQUAL 0)
  message(STATUS \"extracting... [error cleanup]\")
  file(REMOVE_RECURSE \"\${ut_dir}\")
  message(FATAL_ERROR \"error: extract of '\${filename}' failed\")
endif()

# Analyze what came out of the tar file
message(STATUS \"extracting... [analysis]\")
file(GLOB contents \"\${ut_dir}/*\")
list(LENGTH contents n)
if(NOT n EQUAL 1 OR NOT IS_DIRECTORY \"\${contents}\")
  set(contents \"\${ut_dir}\")
endif()

# Move \"the one\" directory to the final directory:
message(STATUS \"extracting... [rename]\")
file(REMOVE_RECURSE \${directory})
get_filename_component(contents \${contents} ABSOLUTE)
file(RENAME \${contents} \${directory})

# Clean up:
message(STATUS \"extracting... [clean up]\")
file(REMOVE_RECURSE \"\${ut_dir}\")

# Done:
message(STATUS \"extracting... done\")
")
endfunction(ScriptExtractFile)

# Name: ScriptCloneGit
# Description: Write a clone script for cloning a GIT repository to the
# directory specified.
# Usage: ScriptCloneGit(script_filename repository directory [tag])
# Example:
# ScriptCloneGit(${PROJECT_BINARY_DIR}/clone.cmake
#   "git://glew.git.sourceforge.net/gitroot/glew/glew"
#   ${PROJECT_BINARY_DIR}/glew
#   "master")
function(ScriptCloneGit script_filename repository directory)
  # Check for optional tag/revision argument
  if(ARGV3)
    set(tag ${ARGV3})
  else(ARGV3)
    set(tag "master")
  endif(ARGV3)

  # Now find GIT executable
  find_package(Git)
  if(NOT GIT_EXECUTABLE)
    message(SEND_ERROR "error: could not find git for clone of '${repository}'")
    return()
  else()
    # Verify the GIT version is > 1.6.5
    execute_process(
      COMMAND "${GIT_EXECUTABLE}" --version
      OUTPUT_VARIABLE out_version
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX REPLACE "^git version (.+)$" "\\1" GIT_VERSION "${out_version}")
    if(GIT_VERSION VERSION_LESS 1.6.5)
      message(SEND_ERROR "error: git version 1.6.5 or later required for 'git submodule update --recursive': git_version='${GIT_VERSION}'")
    endif()
  endif()

  # Setup GIT repository information
  set(module "")
  configure_file(
    "${CMAKE_ROOT}/Modules/RepositoryInfo.txt.in"
    "${PROJECT_BINARY_DIR}/RepositoryInfo.txt"
    @ONLY)

  # Now write the script file
  file(WRITE ${script_filename} "
if(NOT EXISTS \"${directory}\")
  execute_process(
    COMMAND \"${CMAKE_COMMAND}\" -E make_directory \"${directory}\"
    COMMAND \"${GIT_EXECUTABLE}\" clone \"${repository}\" \"${directory}\"
    WORKING_DIRECTORY \"${PROJECT_BINARY_DIR}\"
    RESULT_VARIABLE error_code)
  if(error_code)
    message(FATAL_ERROR \"Failed to clone repository: '${repository}'\")
  endif(error_code)
endif()

execute_process(
  COMMAND \"${GIT_EXECUTABLE}\" checkout ${tag}
  WORKING_DIRECTORY \"${directory}\"
  RESULT_VARIABLE error_code)
if(error_code)
  message(FATAL_ERROR \"Failed to checkout tag: '${tag}'\")
endif(error_code)

execute_process(
  COMMAND \"${GIT_EXECUTABLE}\" submodule init
  WORKING_DIRECTORY \"${directory}\"
  RESULT_VARIABLE error_code)
if(error_code)
  message(FATAL_ERROR \"Failed to init submodules in: '${directory}'\")
endif(error_code)

execute_process(
  COMMAND \"${GIT_EXECUTABLE}\" submodule update --recursive
  WORKING_DIRECTORY \"${directory}\"
  RESULT_VARIABLE error_code
  )
if(error_code)
  message(FATAL_ERROR \"Failed to update submodules in: '${directory}'\")
endif(error_code)
")
endfunction(ScriptCloneGit)

# Name: ScriptCloneMercurial
# Description: Write a clone script for cloning a Mercurial repository to the
# directory specified.
# Usage: ScriptCloneMercurial(script_filename repository directory [tag])
# Example:
# ScriptCloneMercurial(${PROJECT_BINARY_DIR}/clone.cmake
#   "https://RyanLindeman@code.google.com/p/gqe"
#   ${PROJECT_BINARY_DIR}/gqe
#   "tip")
function(ScriptCloneMercurial script_filename repository directory)
  # Check for optional tag/revision argument
  if(ARGV3)
    set(tag ${ARGV3})
  else(ARGV3)
    set(tag "tip")
  endif(ARGV3)

  # Find the mercurial executable
  find_package(Mercurial)
  if(NOT MERCURIAL_EXECUTABLE)
    message(SEND_ERROR "error: could not find mercurial for clone of '${repository}'")
    return()
  endif()

  # Setup Mecurial repository information
  set(module "")
  configure_file(
    "${CMAKE_ROOT}/Modules/RepositoryInfo.txt.in"
    "${PROJECT_BINARY_DIR}/RepositoryInfo.txt"
    @ONLY)

  # Now write the script file
  file(WRITE ${script_filename} "
if(NOT EXISTS \"${directory}\")
  execute_process(
    COMMAND \"${CMAKE_COMMAND}\" -E make_directory \"${directory}\"
    COMMAND \"${MERCURIAL_EXECUTABLE}\" clone -U \"${repository}\" \"${directory}\"
    WORKING_DIRECTORY \"${PROJECT_BINARY_DIR}\"
    RESULT_VARIABLE error_code)
  if(error_code)
    message(FATAL_ERROR \"Failed to clone repository '${repository}'\")
  endif(error_code)
endif()

execute_process(
  COMMAND \"${MERCURIAL_EXECUTABLE}\" update -c null
  WORKING_DIRECTORY \"${directory}\"
  RESULT_VARIABLE error_code)
if(error_code)
  message(WARNING \"Error updating (have you changed its files?): '${directory}'\")
endif(error_code)

execute_process(
  COMMAND \"${MERCURIAL_EXECUTABLE}\" update -r ${tag}
  WORKING_DIRECTORY \"${directory}\"
  RESULT_VARIABLE error_code)
if(error_code)
  message(FATAL_ERROR \"Error updating '${directory}' to tag '${tag}'\")
endif(error_code)
")
endfunction(ScriptCloneMercurial)

# Name: ScriptCloneSubversion
# Description: Write a clone script for cloning a Subversion repository to the
# directory specified.
# Usage: ScriptCloneSubversion(script_filename repository directory [revision] [user] [password])
# Example:
# ScriptCloneSubversion(${PROJECT_BINARY_DIR}/clone.cmake
#   "http://www.somewhere.com/svn"
#   ${PROJECT_BINARY_DIR}/mysvnstuff
#   "myuser"
#   "mypassword"
#   "tip")
function(ScriptCloneSubversion script_filename repository directory)
  # Check for optional tag/revision argument
  if(ARGV3)
    set(tag ${ARGV3})
    set(tag_arg "--revision ${tag}")
  else(ARGV3)
    set(tag_arg "")
  endif(ARGV3)

  # Check for optional user argument
  if(ARGV4)
    set(user_arg "--username ${ARGV4}")
  else(ARGV4)
    set(user_arg "")
  endif(ARGV4)

  # Check for optional user argument
  if(ARGV5)
    set(password_arg "--password ${ARGV5}")
  else(ARGV5)
    set(password_arg "")
  endif(ARGV5)

  # Look for Subversion executable
  find_package(Subversion)
  if(NOT Subversion_SVN_EXECUTABLE)
    message(SEND_ERROR "error: could not find subversion for clone of '${repository}'")
    return()
  endif()

  # Setup Subversion repository information
  set(module "")
  configure_file(
    "${CMAKE_ROOT}/Modules/RepositoryInfo.txt.in"
    "${PROJECT_BINARY_DIR}/RepositoryInfo.txt"
    @ONLY)

  # Now write the script file
  file(WRITE ${script_filename} "
if(NOT EXISTS \"${directory}\")
  execute_process(
    COMMAND \"${CMAKE_COMMAND}\" -E make_directory \"${directory}\"
    COMMAND \"${Subversion_SVN_EXECUTABLE}\" co ${repository} ${tag_arg} --non-interactive ${user_arg} ${password_arg} \"${directory}\"
    WORKING_DIRECTORY \"${PROJECT_BINARY_DIR}\"
    RESULT_VARIABLE error_code)
  if(error_code)
    message(FATAL_ERROR \"Failed to clone repository '${repository}'\")
  endif(error_code)
endif()
")
endfunction(ScriptCloneSubversion)

