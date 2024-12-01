cmake_minimum_required(VERSION 3.18.0)

project(glfanim)

# set Nim paths
cmake_path(SET NIM_DIR NORMALIZE "${CMAKE_CURRENT_SOURCE_DIR}/../../../..")
find_program(NIM_CMD nim)
if(NOT NIM_CMD)
  message(FATAL_ERROR "Cannot find Nim")
endif()
execute_process(COMMAND ${NIM_CMD} e ${NIM_DIR}/version.nims OUTPUT_VARIABLE NIM_LIB_DIR)

add_subdirectory(glfm)

link_libraries(glfm)

include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${NIM_LIB_DIR})


add_custom_command(
  OUTPUT nimcache/@mglfanim.nim.c 
  COMMAND ${NIM_CMD} c -c --cpu:arm64 --os:android -d:androidNDK --app:lib --nimcache:${CMAKE_CURRENT_SOURCE_DIR}/nimcache glfanim.nim
  DEPENDS ${NIM_DIR}/glfanim.nim
  WORKING_DIRECTORY ${NIM_DIR}
)
# message(STATUS ${NIM_RESULT})
add_custom_target(nimcache
  DEPENDS nimcache/@mglfanim.nim.c
)

file(GLOB SOURCES CONFIGURE_DEPENDS "nimcache/*.c")
message(STATUS ${SOURCES})

# for nimbase.h
add_library(glfanim SHARED ${SOURCES})

add_dependencies(glfanim nimcache)



