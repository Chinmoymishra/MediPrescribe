# This file is used to manage the dependencies of your Flutter Windows project.
#
# Instructions for updating this file can be found in the [Getting Started with Windows](https://github.com/google/app-engine-emulator/wiki/Getting-Started-with-Windows) page of the Flutter documentation.

project(MediPrescribe LANGUAGES CXX)

# The name of the executable created for the application. Changing this will cause package
# structure changes downstream.
set(BINARY_NAME "mediprescribe")

cmake_minimum_required(VERSION 3.14)

set(PROJECT_VERSION "1.0.0")

# Invoke the build for generated Dart bindings.
add_subdirectory("flutter/ephemeral")

# "Compile" the generated Dart code to the host architecture so that
# you can execute the Dart VM and execute the Dart compiler for AOT compilation
# on test cases can be invoked.
#
# AOT compilation uses the native architecture to compile the Dart VM and
# the kernel for JIT runs can constrain only to the features the
# Android emulator supports of the native hosts.
set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} /EHsc")

# Configure the root CMakeLists.txt.
string(APPEND CMAKE_CXX_FLAGS " /EHsc")

add_executable(${BINARY_NAME}
  "runner.cpp"
  "utils.cpp"
  "win32_window.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
  "Runner.rc"
)

apply_standard_settings(${BINARY_NAME})

target_compile_definitions(${BINARY_NAME} PRIVATE "NOMINMAX")
target_compile_definitions(${BINARY_NAME} PRIVATE "_USE_MATH_DEFINES")

target_link_libraries(${BINARY_NAME} PRIVATE flutter flutter_wrapper_app)

add_dependencies(${BINARY_NAME} flutter_assemble)
