#! /bin/sh
AC_VERSION=

test -n "$SRC_DIR" || SRC_DIR=$(dirname "$0")
test -n "$SRC_DIR" || SRC_DIR=.

OLD_DIR=$(pwd)
cd "$SRC_DIR"

AUTOMAKE=${AUTOMAKE:-automake}
AM_INSTALLED_VERSION=$($AUTOMAKE --version | sed -e '2,$ d' -e 's/.* \([0-9]*\.[0-9]*\).*/\1/')

AM_MAJOR=${AM_INSTALLED_VERSION%%.*}
AM_MINOR=${AM_INSTALLED_VERSION#*.}
AM_MAJOR=${AM_MAJOR:-0}
AM_MINOR=${AM_MINOR:-0}
if test "$AM_MAJOR" -lt 1 ||
   { test "$AM_MAJOR" -eq 1 && test "$AM_MINOR" -lt 11; }; then
	echo
	echo "You must have automake >= 1.11 installed."
	echo "Install the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnu.org/gnu/automake/"
	exit 1
fi


if [ "x${ACLOCAL_DIR}" != "x" ]; then
    ACLOCAL_ARG=-I ${ACLOCAL_DIR}
fi

GTKDOCIZE=`which gtkdocize`

if test "x${GTKDOCIZE}" = x; then
    echo "You need gtk-doc to build this package."
    echo "http://www.gtk.org/gtk-doc/"
    exit 1
fi

test -d m4 || mkdir m4
set -ex

gtkdocize --copy
${ACLOCAL:-aclocal$AM_VERSION} ${ACLOCAL_ARG}
${AUTOHEADER:-autoheader$AC_VERSION} --force
AUTOMAKE=$AUTOMAKE libtoolize -c --automake --force
AUTOMAKE=$AUTOMAKE intltoolize -c --automake --force
$AUTOMAKE --add-missing --copy --include-deps
${AUTOCONF:-autoconf$AC_VERSION}

rm -rf autom4te.cache

if test -n "$DOCONFIGURE"; then
	./configure $@
fi

cd "$OLD_DIR"
