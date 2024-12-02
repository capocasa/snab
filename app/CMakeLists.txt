cmake_minimum_required(VERSION 3.18.0)

project(glfanim)


## SET UP NIM COMPILE

# get path with nim sources
cmake_path(SET NIM_SOURCE_DIR NORMALIZE "${CMAKE_CURRENT_SOURCE_DIR}/..")

# find a nim compiler
find_program(NIM_CMD nim)
if(NOT NIM_CMD)
  message(FATAL_ERROR "Cannot find Nim")
endif()

# get nim lib directory with nimbase.h
execute_process(
  COMMAND ${NIM_CMD} --hints:off --verbosity:0 e ${NIM_SOURCE_DIR}/version.nims
  OUTPUT_VARIABLE NIM_LIB_DIR)

# map nim CPU names to android arch
set(NIM_CPU_arm64 arm64)
set(NIM_CPU_arm arm)
set(NIM_CPU_x86 i386)
set(NIM_CPU_x86_64 amd64)

set(NIM_CPU ${NIM_CPU_${ANDROID_ARCH_NAME}})

# compile C files into an ephemeral nimcache directory
execute_process(
  COMMAND ${NIM_CMD} c -c -f --cpu:${NIM_CPU} --os:android -d:androidNDK --noMain:on --app:lib --nimcache:${CMAKE_CURRENT_BINARY_DIR}/nimcache ${NIM_SOURCE_DIR}/glfanim.nim
)

### COMPILE C CODE
  
include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${NIM_LIB_DIR}
  ${CMAKE_CURRENT_BINARY_DIR}/nimcache
  ${CMAKE_CURRENT_SOURCE_DIR}/glfm/include
)
# add android activity symbol
# more info: https://github.com/android-ndk/ndk/issues/381
set(CMAKE_SHARED_LINKER_FLAGS
    "${CMAKE_SHARED_LINKER_FLAGS} -v -u ANativeActivity_onCreate")

# compile generated sources
file(
  GLOB NIMCACHE_SOURCES
  CONFIGURE_DEPENDS
  ${CMAKE_CURRENT_BINARY_DIR}/nimcache/*.c
)
add_library(
  glfanim
  SHARED
  ${NIMCACHE_SOURCES}
  ${CMAKE_CURRENT_SOURCE_DIR}/glfm/src/glfm_android.c
)

target_link_libraries(glfanim android EGL GLESv2 log)

