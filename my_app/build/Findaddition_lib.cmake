

function(conan_message MESSAGE_OUTPUT)
    if(NOT CONAN_CMAKE_SILENT_OUTPUT)
        message(${ARGV${0}})
    endif()
endfunction()


macro(conan_find_apple_frameworks FRAMEWORKS_FOUND FRAMEWORKS FRAMEWORKS_DIRS)
    if(APPLE)
        foreach(_FRAMEWORK ${FRAMEWORKS})
            # https://cmake.org/pipermail/cmake-developers/2017-August/030199.html
            find_library(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND NAMES ${_FRAMEWORK} PATHS ${FRAMEWORKS_DIRS} CMAKE_FIND_ROOT_PATH_BOTH)
            if(CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND)
                list(APPEND ${FRAMEWORKS_FOUND} ${CONAN_FRAMEWORK_${_FRAMEWORK}_FOUND})
            else()
                message(FATAL_ERROR "Framework library ${_FRAMEWORK} not found in paths: ${FRAMEWORKS_DIRS}")
            endif()
        endforeach()
    endif()
endmacro()


function(conan_package_library_targets libraries package_libdir deps out_libraries out_libraries_target build_type package_name)
    unset(_CONAN_ACTUAL_TARGETS CACHE)
    unset(_CONAN_FOUND_SYSTEM_LIBS CACHE)
    foreach(_LIBRARY_NAME ${libraries})
        find_library(CONAN_FOUND_LIBRARY NAMES ${_LIBRARY_NAME} PATHS ${package_libdir}
                     NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
        if(CONAN_FOUND_LIBRARY)
            conan_message(STATUS "Library ${_LIBRARY_NAME} found ${CONAN_FOUND_LIBRARY}")
            list(APPEND _out_libraries ${CONAN_FOUND_LIBRARY})
            if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
                # Create a micro-target for each lib/a found
                string(REGEX REPLACE "[^A-Za-z0-9.+_-]" "_" _LIBRARY_NAME ${_LIBRARY_NAME})
                set(_LIB_NAME CONAN_LIB::${package_name}_${_LIBRARY_NAME}${build_type})
                if(NOT TARGET ${_LIB_NAME})
                    # Create a micro-target for each lib/a found
                    add_library(${_LIB_NAME} UNKNOWN IMPORTED)
                    set_target_properties(${_LIB_NAME} PROPERTIES IMPORTED_LOCATION ${CONAN_FOUND_LIBRARY})
                    set(_CONAN_ACTUAL_TARGETS ${_CONAN_ACTUAL_TARGETS} ${_LIB_NAME})
                else()
                    conan_message(STATUS "Skipping already existing target: ${_LIB_NAME}")
                endif()
                list(APPEND _out_libraries_target ${_LIB_NAME})
            endif()
            conan_message(STATUS "Found: ${CONAN_FOUND_LIBRARY}")
        else()
            conan_message(STATUS "Library ${_LIBRARY_NAME} not found in package, might be system one")
            list(APPEND _out_libraries_target ${_LIBRARY_NAME})
            list(APPEND _out_libraries ${_LIBRARY_NAME})
            set(_CONAN_FOUND_SYSTEM_LIBS "${_CONAN_FOUND_SYSTEM_LIBS};${_LIBRARY_NAME}")
        endif()
        unset(CONAN_FOUND_LIBRARY CACHE)
    endforeach()

    if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
        # Add all dependencies to all targets
        string(REPLACE " " ";" deps_list "${deps}")
        foreach(_CONAN_ACTUAL_TARGET ${_CONAN_ACTUAL_TARGETS})
            set_property(TARGET ${_CONAN_ACTUAL_TARGET} PROPERTY INTERFACE_LINK_LIBRARIES "${_CONAN_FOUND_SYSTEM_LIBS};${deps_list}")
        endforeach()
    endif()

    set(${out_libraries} ${_out_libraries} PARENT_SCOPE)
    set(${out_libraries_target} ${_out_libraries_target} PARENT_SCOPE)
endfunction()


include(FindPackageHandleStandardArgs)

conan_message(STATUS "Conan: Using autogenerated Findaddition_lib.cmake")
# Global approach
set(addition_lib_FOUND 1)
set(addition_lib_VERSION "1.0")

find_package_handle_standard_args(addition_lib REQUIRED_VARS
                                  addition_lib_VERSION VERSION_VAR addition_lib_VERSION)
mark_as_advanced(addition_lib_FOUND addition_lib_VERSION)


set(addition_lib_INCLUDE_DIRS "/home/dev/.conan/data/addition_lib/1.0/salah/salah/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(addition_lib_INCLUDE_DIR "/home/dev/.conan/data/addition_lib/1.0/salah/salah/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(addition_lib_INCLUDES "/home/dev/.conan/data/addition_lib/1.0/salah/salah/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/include")
set(addition_lib_RES_DIRS )
set(addition_lib_DEFINITIONS )
set(addition_lib_LINKER_FLAGS_LIST
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:>"
        "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:>"
)
set(addition_lib_COMPILE_DEFINITIONS )
set(addition_lib_COMPILE_OPTIONS_LIST "" "")
set(addition_lib_COMPILE_OPTIONS_C "")
set(addition_lib_COMPILE_OPTIONS_CXX "")
set(addition_lib_LIBRARIES_TARGETS "") # Will be filled later, if CMake 3
set(addition_lib_LIBRARIES "") # Will be filled later
set(addition_lib_LIBS "") # Same as addition_lib_LIBRARIES
set(addition_lib_SYSTEM_LIBS )
set(addition_lib_FRAMEWORK_DIRS )
set(addition_lib_FRAMEWORKS )
set(addition_lib_FRAMEWORKS_FOUND "") # Will be filled later
set(addition_lib_BUILD_MODULES_PATHS )

conan_find_apple_frameworks(addition_lib_FRAMEWORKS_FOUND "${addition_lib_FRAMEWORKS}" "${addition_lib_FRAMEWORK_DIRS}")

mark_as_advanced(addition_lib_INCLUDE_DIRS
                 addition_lib_INCLUDE_DIR
                 addition_lib_INCLUDES
                 addition_lib_DEFINITIONS
                 addition_lib_LINKER_FLAGS_LIST
                 addition_lib_COMPILE_DEFINITIONS
                 addition_lib_COMPILE_OPTIONS_LIST
                 addition_lib_LIBRARIES
                 addition_lib_LIBS
                 addition_lib_LIBRARIES_TARGETS)

# Find the real .lib/.a and add them to addition_lib_LIBS and addition_lib_LIBRARY_LIST
set(addition_lib_LIBRARY_LIST addition_lib)
set(addition_lib_LIB_DIRS "/home/dev/.conan/data/addition_lib/1.0/salah/salah/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/lib")

# Gather all the libraries that should be linked to the targets (do not touch existing variables):
set(_addition_lib_DEPENDENCIES "${addition_lib_FRAMEWORKS_FOUND} ${addition_lib_SYSTEM_LIBS} ")

conan_package_library_targets("${addition_lib_LIBRARY_LIST}"  # libraries
                              "${addition_lib_LIB_DIRS}"      # package_libdir
                              "${_addition_lib_DEPENDENCIES}"  # deps
                              addition_lib_LIBRARIES            # out_libraries
                              addition_lib_LIBRARIES_TARGETS    # out_libraries_targets
                              ""                          # build_type
                              "addition_lib")                                      # package_name

set(addition_lib_LIBS ${addition_lib_LIBRARIES})

foreach(_FRAMEWORK ${addition_lib_FRAMEWORKS_FOUND})
    list(APPEND addition_lib_LIBRARIES_TARGETS ${_FRAMEWORK})
    list(APPEND addition_lib_LIBRARIES ${_FRAMEWORK})
endforeach()

foreach(_SYSTEM_LIB ${addition_lib_SYSTEM_LIBS})
    list(APPEND addition_lib_LIBRARIES_TARGETS ${_SYSTEM_LIB})
    list(APPEND addition_lib_LIBRARIES ${_SYSTEM_LIB})
endforeach()

# We need to add our requirements too
set(addition_lib_LIBRARIES_TARGETS "${addition_lib_LIBRARIES_TARGETS};")
set(addition_lib_LIBRARIES "${addition_lib_LIBRARIES};")

set(CMAKE_MODULE_PATH "/home/dev/.conan/data/addition_lib/1.0/salah/salah/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/" ${CMAKE_MODULE_PATH})
set(CMAKE_PREFIX_PATH "/home/dev/.conan/data/addition_lib/1.0/salah/salah/package/6557f18ca99c0b6a233f43db00e30efaa525e27e/" ${CMAKE_PREFIX_PATH})

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.0")
    # Target approach
    if(NOT TARGET addition_lib::addition_lib)
        add_library(addition_lib::addition_lib INTERFACE IMPORTED)
        if(addition_lib_INCLUDE_DIRS)
            set_target_properties(addition_lib::addition_lib PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
                                  "${addition_lib_INCLUDE_DIRS}")
        endif()
        set_property(TARGET addition_lib::addition_lib PROPERTY INTERFACE_LINK_LIBRARIES
                     "${addition_lib_LIBRARIES_TARGETS};${addition_lib_LINKER_FLAGS_LIST}")
        set_property(TARGET addition_lib::addition_lib PROPERTY INTERFACE_COMPILE_DEFINITIONS
                     ${addition_lib_COMPILE_DEFINITIONS})
        set_property(TARGET addition_lib::addition_lib PROPERTY INTERFACE_COMPILE_OPTIONS
                     "${addition_lib_COMPILE_OPTIONS_LIST}")
        
    endif()
endif()

foreach(_BUILD_MODULE_PATH ${addition_lib_BUILD_MODULES_PATHS})
    include(${_BUILD_MODULE_PATH})
endforeach()
