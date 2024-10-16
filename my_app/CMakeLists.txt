cmake_minimum_required(VERSION 3.15)
project(my_app)

set(CMAKE_CXX_STANDARD 14)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

find_package(addition_lib REQUIRED)

add_executable(my_app src/main.cpp)
target_include_directories(my_app PUBLIC include ${addition_lib_INCLUDE_DIRS})
target_link_libraries(my_app addition_lib)
