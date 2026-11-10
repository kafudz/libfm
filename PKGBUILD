# Maintainer: kafudz <kafudzsocial@gmail.com>

# Set to 2 to build against GTK2 instead of GTK3
_gtk=3

pkgname=libfm-kafudz-git
_pkgname=libfm
pkgver=1.4.1.r2.g0972a28
pkgrel=1
pkgdesc="Library for file management (kafudz fork, git version)"
arch=('x86_64' 'aarch64')
url="https://github.com/kafudz/libfm"
license=('LGPL-2.1-or-later OR GPL-2.0-or-later')
depends=('glib2' 'glibc' 'libexif' 'menu-cache')
if [[ $_gtk == 3 ]]; then
  depends+=('gtk3' 'at-spi2-core' 'cairo' 'gdk-pixbuf2' 'pango')
else
  depends+=('gtk2' 'cairo' 'gdk-pixbuf2' 'pango')
fi
makedepends=('git' 'vala' 'intltool' 'gtk-doc' 'glib2-devel' 'autoconf' 'automake' 'libtool' 'pkgconf')
provides=("libfm=${pkgver%%.r*}" "libfm-extra=${pkgver%%.r*}")
if [[ $_gtk == 3 ]]; then
  provides+=("libfm-gtk3=${pkgver%%.r*}")
else
  provides+=("libfm-gtk2=${pkgver%%.r*}")
fi
conflicts=('libfm' 'libfm-extra' 'libfm-gtk2' 'libfm-gtk3' 'lxshortcut')
backup=('etc/xdg/libfm/libfm.conf')
source=("$_pkgname::git+$url.git")
sha256sums=('SKIP')

pkgver() {
  cd "$srcdir/$_pkgname"
  # e.g. 1.4.1-2-g0972a281 -> 1.4.1.r2.g0972a281
  git describe --long --tags --abbrev=7 2>/dev/null \
    | sed 's/^v//;s/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
  cd "$srcdir/$_pkgname"
  ./autogen.sh
  ./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --with-gtk=$_gtk \
    --disable-static \
    --disable-gtk-doc
  make
}

package() {
  cd "$srcdir/$_pkgname"
  make DESTDIR="$pkgdir" install
}
