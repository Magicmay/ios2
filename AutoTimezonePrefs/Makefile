TARGET := iphone:clang:16.5:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AutoTimezonePrefs

AutoTimezonePrefs_FILES = AutoTimezonePrefsRootListController.m
AutoTimezonePrefs_FRAMEWORKS = UIKit
AutoTimezonePrefs_PRIVATE_FRAMEWORKS = Preferences
AutoTimezonePrefs_INSTALL_PATH = /Library/PreferenceBundles
AutoTimezonePrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
