cmake_minimum_required(VERSION 3.18.0)


## SETTINGS

# project name
project(snab)

# Nim source file (defaults to projectname.nim but change to anything you like)
SET(NIM_SOURCE_FILENAME ${CMAKE_PROJECT_NAME}.nim)

# Nim source directory defaults to repository root but change to anything you like
cmake_path(SET NIM_SOURCE_DIR NORMALIZE "${CMAKE_CURRENT_SOURCE_DIR}/../")

## SET UP NIM COMPILE

# find a nim compiler
find_program(NIM_CMD nim)
if(NOT NIM_CMD)
  message(FATAL_ERROR "Cannot find Nim")
endif()

# get nim lib directory with nimbase.h
execute_process(
  COMMAND ${NIM_CMD} --hints:off --verbosity:0 e ${CMAKE_CURRENT_SOURCE_DIR}/version.nims
  OUTPUT_VARIABLE NIM_LIB_DIR
  COMMAND_ERROR_IS_FATAL ANY
)

# map nim CPU names to android arch
set(NIM_CPU_arm64 arm64)
set(NIM_CPU_arm arm)
set(NIM_CPU_x86 i386)
set(NIM_CPU_x86_64 amd64)

set(NIM_CPU ${NIM_CPU_${ANDROID_ARCH_NAME}})

set(NIM_RELEASE_FLAGS_Debug )
set(NIM_RELEASE_FLAGS_RelWithDebInfo -d:danger --opt:speed)
set(NIM_RELEASE_FLAGS_Release -d:danger --opt:speed) # not ordinarily needed

set(NIM_RELEASE_FLAGS ${NIM_RELEASE_FLAGS_${CMAKE_BUILD_TYPE}})

# compile C files into an ephemeral nimcache directory
file(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/nimcache/*)
execute_process(
  COMMAND ${NIM_CMD} c -c -f --cpu:${NIM_CPU} --os:android -d:androidNDK --noMain:on --app:lib --nimcache:${CMAKE_CURRENT_BINARY_DIR}/nimcache ${NIM_RELEASE_FLAGS} ${NIM_SOURCE_DIR}/${NIM_SOURCE_FILENAME}
  COMMAND_ERROR_IS_FATAL ANY
  RESULT_VARIABLE NIM_RESULT
)

# trigger rebuild if nim file changes
# add further files here
set_property(
  DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
  ${NIM_SOURCE_DIR}/${NIM_SOURCE_FILENAME}
)

### Add SDL

add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/SDL2")
find_library(SDL2 SDL2)
add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/SDL2_ttf")
find_library(SDL2_ttf SDL2_ttf)

### COMPILE C CODE
  
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${NIM_LIB_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}/nimcache
)

# compile generated sources
file(
  GLOB NIMCACHE_SOURCES
  CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_BINARY_DIR}/nimcache/*.c
)
add_library(
  ${CMAKE_PROJECT_NAME}
  SHARED
  ${NIMCACHE_SOURCES}
)

target_link_libraries(${CMAKE_PROJECT_NAME} SDL2 SDL2_ttf log)

