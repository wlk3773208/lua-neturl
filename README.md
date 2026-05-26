# lua-neturl
在使用 APK 作为包管理器的 OpenWrt 版本（如 ImmortalWrt 主线）编译 lua-neturl 时出现错误。根本原因有两个：

APK 版本号格式要求
APK 要求版本号中的 Release 部分必须以字母 r 作为前缀（例如 1.2-r1），而原有的 PKG_VERSION=1.2-1 包含连字符 -，导致构建系统解析失败，报错：

ERROR: info field 'version' has invalid value: package version is invalid
源码解压目录不一致
将 PKG_VERSION 改为 1.2 后，构建系统会在 build_dir/target-*/ 下同时生成两个目录：

neturl-1.2（空目录，用作 PKG_BUILD_DIR）

neturl-1.2-1（实际解压出的源码目录）
补丁文件默认应用在 neturl-1.2 这个空目录上，导致补丁失败：


can't find file to patch at input line 3
No file to patch. Skipping patch.
临时解决方案：

我通过覆盖 Build/Prepare 步骤，手动控制解压过程解决了该问题。核心代码如下：

makefile
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	rm -rf $(PKG_BUILD_DIR)/*
	tar -C $(PKG_BUILD_DIR) --strip-components=1 -xf $(DL_DIR)/$(PKG_SOURCE)
endef
