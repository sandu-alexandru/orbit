cmake_minimum_required(VERSION 3.10)
project(orbit_cpp_service)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required packages
find_package(Boost REQUIRED COMPONENTS system)
find_package(OpenSSL REQUIRED)

# Add AMQP-CPP library path
set(AMQP_CPP_DIR "/usr/local")
set(AMQP_CPP_INCLUDE_DIR "${AMQP_CPP_DIR}/include")
set(AMQP_CPP_LIB_DIR "${AMQP_CPP_DIR}/lib")

# Add the executable
add_executable(orbit_cpp_service src/main.cpp)

# Include directories
target_include_directories(orbit_cpp_service PRIVATE
    ${Boost_INCLUDE_DIRS}
    ${OPENSSL_INCLUDE_DIR}
    ${AMQP_CPP_INCLUDE_DIR}
)

# Link directories
link_directories(${AMQP_CPP_LIB_DIR})

# Link libraries
target_link_libraries(orbit_cpp_service PRIVATE
    ${Boost_LIBRARIES}
    ${OPENSSL_LIBRARIES}
    -L${AMQP_CPP_LIB_DIR}
    -lamqpcpp
    -lpthread
    -ldl
)

# Set installation rules
install(TARGETS orbit_cpp_service DESTINATION bin)
