from conans import ConanFile, CMake

class MyAppConan(ConanFile):
    name = "my_app"
    version = "1.0"
    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake", "cmake_find_package"
    requires = "addition_lib/1.0@salah/salah"

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder=".")
        cmake.build()
