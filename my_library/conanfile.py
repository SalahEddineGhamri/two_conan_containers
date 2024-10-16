from conans import ConanFile, CMake

class AdditionLibConan(ConanFile):
    name = "addition_lib"
    version = "1.0"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": False, "fPIC": True}
    generators = "cmake"
    exports_sources = "CMakeLists.txt", "src/*", "include/*"

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder=".")
        cmake.build()

    def package(self):
        self.copy("*.h", dst="include", src="include")
        self.copy("*.lib", dst="lib", keep_path=False)
        self.copy("*.dll", dst="bin", keep_path=False)
        self.copy("*.so", dst="lib", keep_path=False)
        self.copy("*.dylib", dst="lib", keep_path=False)
        self.copy("*.a", dst="lib", keep_path=False)
        self.copy("*.txt", dst=".", keep_path=False)

    def package_info(self):
        self.cpp_info.libs = ["addition_lib"]
        self.cpp_info.set_property("cmake_file_name", "addition_lib")
        self.cpp_info.set_property("cmake_target_name", "addition::lib")
