TARGET := iphone:clang:16.5:14.0
ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AutoTimezone

AutoTimezone_FILES = Tweak.x
AutoTimezone_CFLAGS = -fobjc-arc
AutoTimezone_FRAMEWORKS = UIKit Foundation CoreLocation
AutoTimezone_PRIVATE_FRAMEWORKS =

include $(THEOS_MAKE_PATH)/tweak.mk
