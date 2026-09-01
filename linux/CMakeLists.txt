cmake_minimum_required(VERSION 3.14)
project(mediprescribe LANGUAGES CXX)

set(BINARY_NAME "mediprescribe")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

set(PROJECT_VERSION "1.0.0")

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")

# Root filesystem for built application.
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/flutter/ephemeral")

# Define build configuration.
get_property(IS_MULTI_CONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(MSVC OR IS_MULTI_CONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release" CACHE STRING "" FORCE)
elseif(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Flutter build mode" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS Debug Profile Release)
endif()

add_subdirectory("flutter")

# System-level dependencies.
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK gtk+-3.0 REQUIRED)
pkg_check_modules(GLIB gio-2.0 glib-2.0 REQUIRED)
pkg_check_modules(X11 x11 REQUIRED)

add_executable(${BINARY_NAME}
  "main.cc"
  "${FLUTTER_MANAGED_DIR}/generated_plugins.cc"
)

apply_standard_settings(${BINARY_NAME})

target_compile_options(${BINARY_NAME} PRIVATE
  ${GTK_CFLAGS_OTHER}
  ${GLIB_CFLAGS_OTHER}
  ${X11_CFLAGS_OTHER}
)

target_include_directories(${BINARY_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${GTK_INCLUDE_DIRS}
  ${GLIB_INCLUDE_DIRS}
  ${X11_INCLUDE_DIRS}
)

target_link_libraries(${BINARY_NAME} PRIVATE
  flutter
  PkgConfig::GTK
  PkgConfig::GLIB
  PkgConfig::X11
  ${GLIB_LIBRARIES}
)

add_dependencies(${BINARY_NAME} flutter_assemble)
