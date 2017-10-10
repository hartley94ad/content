set(OPENSCAP_POSSIBLE_ROOT_DIRS
    "${OPENSCAP_ROOT_DIR}"
    "$ENV{OPENSCAP_ROOT_DIR}"
    "$ENV{ProgramFiles}"
    "/usr"
    "/usr/bin"
    "/usr/sbin"
    "/usr/local"
    "/usr/share/"
    "/usr/local/share"
    "/opt"
    "/opt/local"
)

foreach(NAME ${OPENSCAP_POSSIBLE_ROOT_DIRS})
    FIND_FILE(OSCAP_XCCDF_XSL_1_2 NAMES xccdf_1.1_to_1.2.xsl
        PATHS "${NAME}"
        PATH_SUFFIXES "share/openscap/xsl/"
    )
endforeach()

foreach(NAME ${OPENSCAP_POSSIBLE_ROOT_DIRS})
    FIND_PROGRAM(OSCAP_EXECUTABLE NAMES oscap
        PATHS "${NAME}"
        PATH_SUFFIXES "bin/"
    )
endforeach()

if (NOT EXISTS "${OSCAP_XCCDF_XSL_1_2}")
    MESSAGE(SEND_ERROR
            "ERROR: The OPENSCAP XSL XCCDF file was not found. Please specify the OPENSCAP ROOT DIR with the OPENSCAP_ROOT_DIR environment variable.")
endif()

if (NOT EXISTS "${OSCAP_EXECUTABLE}")
    MESSAGE(SEND_ERROR
            "ERROR: The OPENSCAP executable was not found. Please specify the OPENSCAP ROOT DIR with the OPENSCAP_ROOT_DIR environment variable.")
endif()

execute_process(
    COMMAND "${OSCAP_EXECUTABLE}" --v
    OUTPUT_VARIABLE OSCAP_V_OUTPUT
)

if("${OSCAP_V_OUTPUT}" MATCHES "^OpenSCAP command line tool \\(oscap\\) ([0-9\\.]+)")
    set(OSCAP_VERSION "${CMAKE_MATCH_1}")
else()
    set(OSCAP_VERSION "unknown")
endif()
