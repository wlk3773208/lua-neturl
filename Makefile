# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2022-2023 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=neturl
PKG_VERSION:=1.2
PKG_RELEASE:=1          # 注意：这里应使用 1 而非 r1，否则会生成 1.2-rr1

UPSTREAM_TAG:=1.2-1
PKG_SOURCE:=$(PKG_NAME)-$(UPSTREAM_TAG).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/golgote/neturl/tar.gz/v$(UPSTREAM_TAG)?
PKG_HASH:=fc4ea1b114125ae821bef385936cd12429485204576e77b6283692bd0cc9b1ab

PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE.txt

include $(INCLUDE_DIR)/package.mk

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	rm -rf $(PKG_BUILD_DIR)/*
	tar -C $(PKG_BUILD_DIR) --strip-components=1 -xf $(DL_DIR)/$(PKG_SOURCE)
endef

define Package/lua-neturl
  SUBMENU:=Lua
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=URL and Query string parser, builder, normalizer for Lua
  URL:=https://github.com/golgote/neturl
  DEPENDS:=+lua
  PKGARCH:=all
endef

define Package/lua-neturl/description
  This small Lua library provides a few functions to parse URL with
  querystring and build new URL easily.
endef

define Build/Compile
endef

define Package/lua-neturl/install
	$(INSTALL_DIR) $(1)/usr/lib/lua
	$(CP) $(PKG_BUILD_DIR)/lib/net/url.lua $(1)/usr/lib/lua/
endef

$(eval $(call BuildPackage,lua-neturl))