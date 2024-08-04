# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Open Firmware device tree compiler"
HOMEPAGE="https://devicetree.org/ https://git.kernel.org/cgit/utils/dtc/dtc.git/"
SRC_URI="https://github.com/dgibson/dtc/tarball/039a99414e778332d8f9c04cbd3072e1dcc62798 -> dtc-1.7.0-039a994.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs yaml"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
RDEPEND="yaml? ( dev-libs/libyaml )"
DEPEND="${RDEPEND}"

DOCS="
	Documentation/dt-object-internal.txt
	Documentation/dts-format.txt
	Documentation/manual.txt
"

_emake() {
	# valgrind is used only in 'make checkm'
	emake \
		NO_PYTHON=1 \
		NO_VALGRIND=1 \
		NO_YAML=$(usex !yaml 1 0) \
		\
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		\
		V=1 \
		\
		PREFIX="${EPREFIX}/usr" \
		\
		LIBDIR="\$(PREFIX)/$(get_libdir)" \
		\
		"$@"
}

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv "${WORKDIR}"/* "${S}" || die
	fi
}

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS =/s:=:+=:' \
		-e '/^CPPFLAGS =/s:=:+=:' \
		-e 's:-Werror::' \
		-e 's:-g -Os::' \
		Makefile || die

	tc-export AR CC PKG_CONFIG
}

src_compile() {
	_emake
}

src_test() {
	_emake check
}

src_install() {
	_emake DESTDIR="${D}" install

	use static-libs || find "${ED}" -name '*.a' -delete
}