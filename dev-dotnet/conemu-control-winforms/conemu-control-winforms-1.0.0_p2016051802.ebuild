# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

USE_DOTNET="net45"
inherit gac dotnet
IUSE+=" +net45 +pkg-config debug"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="console emulator control, embeds a console view in a Windows Forms window"
HOMEPAGE="http://conemu.github.io/"
SRC_URI="http://download.mono-project.com/sources/mono/mono-4.6.0.150.tar.bz2"
RESTRICT="mirror"

NAME="conemu-inside"
HOMEPAGE="https://github.com/Maximus5/${NAME}"

EGIT_COMMIT="b4800195f09b86eca14c4b96141a78136ee1d872"
SRC_URI="${HOMEPAGE}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${NAME}-${EGIT_COMMIT}"

LICENSE="BSD" # https://github.com/Maximus5/ConEmu/blob/master/Release/ConEmu/License.txt
SLOT="0"

src_prepare() {
	eapply "${FILESDIR}/add-release-configuration.patch"
	eapply_user
}

src_compile() {
	if use debug; then
		CONFIGURATION=Debug
	else
		CONFIGURATION=Release
	fi
	exbuild_raw /p:SignAssembly=true /p:AssemblyOriginatorKeyFile="${S}/ConEmuWinForms/Snk.Snk" /p:VersionNumber=1.0.0.2016051802 /p:Configuration=${CONFIGURATION} ConEmuWinForms/ConEmuWinForms.csproj
}

src_install() {
	if use debug; then
		DIR=Debug
	else
		DIR=Release
	fi
	egacinstall "${S}/ConEmuWinForms/bin/${DIR}/ConEmu.WinForms.dll"
	einstall_pc_file "${PN}" "${NAME}.dll"
}
