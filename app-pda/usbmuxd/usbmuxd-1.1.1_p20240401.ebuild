# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd udev

DESCRIPTION="USB multiplex daemon for use with Apple iPhone/iPod Touch devices"
HOMEPAGE="https://libimobiledevice.org/"
SRC_URI="https://github.com/libimobiledevice/usbmuxd/archive/360619c5f721f93f0b9d8af1a2df0b926fbcf281.zip -> usbmuxd-1.1.1_p20240401-360619c.zip"

# src/utils.h is LGPL-2.1+, rest is found in COPYING*
LICENSE="GPL-2 GPL-3 LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	>=app-pda/libimobiledevice-1.0:=
	>=app-pda/libplist-2.0:=
	virtual/libusb:1"

RDEPEND="
	${DEPEND}
	virtual/udev
"

BDEPEND="
	virtual/pkgconfig
"

post_src_unpack() {
	if [ ! -d "${WORKDIR}/${S}" ]; then
		mv "${WORKDIR}"/* "${S}" || die
	fi
}

src_prepare() {
	default
	echo "${PVR}" > .tarball-version
	eautoreconf
}