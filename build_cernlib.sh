#!/bin/bash

    echo "================================================================================"
    echo " Checking build environment"
    echo "================================================================================"

    if [ -z "`which make 2>/dev/null`" ]; then
        echo "*** System package make was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "make has been found."

    if [ -z "`which gmake 2>/dev/null`" ]; then
        echo "*** gmake was not found. Please install it or - if you only have make - create a symlink, e.g."
        echo "    ln -sfn `which make` /usr/bin/gmake"
        echo ""
        exit 1
    fi
    echo "gmake has been found."

    if [ -z "`which imake 2>/dev/null`" ]; then
        echo "*** System package imake (or xutils-dev) was not found. Please install before compiling this package!"
        echo "*** A standalone version can be built with: build_xutils_imake_makedepend.sh"
        echo ""
        exit 1
    fi
    echo "imake has been found."

    if [ -z "`which makedepend 2>/dev/null`" ]; then
        echo "*** System package makedepend (or xutils-dev) was not found. Please install before compiling this package!"
        echo "*** A standalone version can be built with: build_xutils_imake_makedepend.sh"
        echo ""
        exit 1
    fi

    if [ ! -f "/usr/include/X11/StringDefs.h" ]; then
        echo "*** System package libXt-devel (or libxt-dev) was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "libXt-devel has been found."

    if [ ! -f "/usr/include/Xm/Xm.h" ]; then
        echo "*** System package openmotif-devel (or libmotif-dev or lesstif-devel) was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "openmotif-devel has been found."

    if [ -z "`find /usr/lib /usr/lib64 -maxdepth 2 -name libgmp.so* 2>/dev/null`" ]; then
        echo "*** System package gmp-devel (or libgmp3-dev) was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "gmp-devel has been found."

    if [ ! -f "/bin/csh" ]; then
        echo "*** System package csh was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "csh has been found."
    if [ ! -f "/bin/tcsh" ]; then
        echo "*** System package tcsh was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "tcsh has been found."

    if [ -z "`which gfortran 2>/dev/null`" ]; then
        echo "*** System package gcc-gfortran was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "gfortran has been found."

    if [ -z "`which ed 2>/dev/null`" ]; then
        echo "*** System package ed was not found. Please install before compiling this package!"
        echo ""
        exit 1
    fi
    echo "ed has been found."

    echo "================================================================================"
    echo " Compiling CERNLIB 2005"
    echo "================================================================================"

./pull_down_and_patch.sh cernlib_build

cd cernlib_build
export CERN=$(readlink -f .)
export CERN_LEVEL=2005
export CERN_ROOT=${CERN}/${CERN_LEVEL}

./Install_cernlib_and_lapack

FILES="libariadne.a  libcojets.a   libfritiof.a   libgeant.a    libgrafX11.a   libherwig.a     libjetset74.a  libkernlib-shift.a  liblepto651.a  libpacklib.a        libpawlib.a     libphotos202.a  libpythia6205.a libblas.a     libeurodec.a  libgeant321.a  libgraflib.a  libherwig59.a  libisajet758.a  libkernlib.a   liblapack3.a        libmathlib.a   libpacklib-shift.a  libpdflib804.a  libphtools.a"
for f in $FILES; do
  if [ ! -f ${CERN_LEVEL}/lib/$f ]; then
    echo "[ERROR]: File 2005/lib/$f is missing, building CERNLIB presumably failed. Please check the build logs."
    exit 1
  fi
done
echo CERNLIB successfully build.

cd ../

echo -e '#!/bin/bash\n'"export CERN=$(readlink -f cernlib_build)\nexport CERN_LEVEL=2005\nexport PATH=\${CERN}/\${CERN_LEVEL}/bin:\${PATH}" > setup_cernlib.sh
