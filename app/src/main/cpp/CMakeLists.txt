cmake_minimum_required(VERSION 3.18.0)

project(glfman)

add_subdirectory(glfm)

link_libraries(glfm)

add_library(glfman SHARED glfman.c)
target_link_libraries(glfman glfm)
set_target_properties(glfman PROPERTIES C_STANDARD 11)
#target_include_directories(glfman, include)


