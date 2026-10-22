
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1
FOR_RELEASE = 1

TARGET := iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ImGui-ModMenu
$(TWEAK_NAME)_USE_MODULES = 0

MenuFiles = $(wildcard Menu/*.mm)
utilsFiles = $(wildcard util/*.cpp)
ImGuiFiles = $(wildcard IMGUI/*.cpp) \
             $(wildcard IMGUI/*.mm)

FloatingFiles = $(wildcard Floating/*.mm) \
                $(wildcard Floating/Utils/*.cpp)

$(TWEAK_NAME)_FILES = $(MenuFiles) $(utilsFiles) $(ImGuiFiles) $(FloatingFiles)

$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation Security QuartzCore CoreGraphics CoreText AVFoundation Accelerate GLKit SystemConfiguration GameController ImageIO CoreFoundation CFNetwork Metal MetalKit

# Include paths
$(TWEAK_NAME)_CFLAGS += -I$(THEOS_PROJECT_DIR)/IMGUI
$(TWEAK_NAME)_CCFLAGS += -I$(THEOS_PROJECT_DIR)/IMGUI

# Compiler options
$(TWEAK_NAME)_CCFLAGS += -std=c++20 -fno-rtti -DNDEBUG -Wno-unused-variable -O0 -Wno-error -fobjc-arc -Wno-format

$(TWEAK_NAME)_CFLAGS += -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable -Wno-writable-strings -O0 -Wno-format

export LDFLAGS += -Wl,-S

include $(THEOS_MAKE_PATH)/tweak.mk
