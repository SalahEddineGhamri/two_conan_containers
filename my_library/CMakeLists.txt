cmake_minimum_required(VERSION 3.15)
project(addition_lib)

set(CMAKE_CXX_STANDARD 14)

add_library(addition_lib src/addition.cpp)
target_include_directories(addition_lib PUBLIC include)

add_executable(test src/main.cpp)
target_link_libraries(test addition_lib)
