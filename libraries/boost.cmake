# -----------------------------------------------------------------------------
#   BALL - Biochemical ALgorithms Library
#   A C++ framework for molecular modeling and structural bioinformatics.
# -----------------------------------------------------------------------------
#
# Copyright (C) 1996-2012, the BALL Team:
#  - Andreas Hildebrandt
#  - Oliver Kohlbacher
#  - Hans-Peter Lenhof
#  - Eberhard Karls University, Tuebingen
#  - Saarland University, Saarbrücken
#  - others
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library (BALL/source/LICENSE); if not, write
#  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
#  Boston, MA  02111-1307  USA
#
# -----------------------------------------------------------------------------
# $Maintainer: Philipp Thiel $
# $Authors: Philipp Thiel $
# -----------------------------------------------------------------------------

MSG_CONFIGURE_PACKAGE_BEGIN("${PACKAGE_NAME}")

# Further packages to be downloaded
LIST(APPEND DOWNLOAD_ARCHIVES "bzip2" "zlib")

# Determine the correct b2 switches according to build type and platform
IF(CONTRIB_BUILD_TYPE STREQUAL "RelWithDebInfo")
	SET(BOOST_BUILD_TYPE "release debug-symbols=on")
ELSE()
	STRING(TOLOWER "${CONTRIB_BUILD_TYPE}" BOOST_BUILD_TYPE)
ENDIF()

# Libraries to be build
SET(BOOST_LIBRARIES "--with-chrono" "--with-date_time" "--with-iostreams" "--with-regex" "--with-serialization" "--with-system" "--with-thread")

# Boost b2 options
SET(BOOST_B2_OPTIONS "link=shared" "threading=multi" "variant=${BOOST_BUILD_TYPE}" "address-model=${CONTRIB_ADDRESSMODEL}")

# Set system dependent variables
IF(MSVC)
	SET(BOOST_BOOTSTRAP_CMD bootstrap.bat)
	SET(BOOST_B2_CMD b2.exe)
ELSE()
	SET(BOOST_BOOTSTRAP_CMD ./bootstrap.sh)
	SET(BOOST_B2_CMD ./b2)
	LIST(APPEND BOOST_B2_OPTIONS "--layout=tagged")
ENDIF()

# Add project
ExternalProject_Add(${PACKAGE_NAME}

	URL "${CONTRIB_ARCHIVES_URL}/${${PACKAGE_NAME}_archive}"
	PREFIX ${PROJECT_BINARY_DIR}
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ${BOOST_BOOTSTRAP_CMD}

	BUILD_COMMAND ${BOOST_B2_CMD}
	install
	-j ${THREADS}
	--prefix=${CONTRIB_INSTALL_BASE}
	${BOOST_B2_OPTIONS}
	${BOOST_LIBRARIES}
	-sBZIP2_SOURCE=${CONTRIB_BINARY_SRC}/${bzip2}
	-sZLIB_SOURCE=${CONTRIB_BINARY_SRC}/${zlib}

	INSTALL_COMMAND ""
)

# Extract bzip2 and zlib archives
ExternalProject_Add_Step(${PACKAGE_NAME} extract_bzip2_zlib

	LOG 1
	DEPENDEES download

	WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}"
	COMMAND cmake -E tar xzf "${CONTRIB_ARCHIVES_PATH}/${bzip2_archive}"
	COMMAND cmake -E tar xzf "${CONTRIB_ARCHIVES_PATH}/${zlib_archive}"

	DEPENDERS configure
)

MSG_CONFIGURE_PACKAGE_END("${PACKAGE_NAME}")






