LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE := qsort

ABI_ARMEABI_V7A := armeabi_v7a
ABI_ARM64_V8A := arm64_v8a

LIB_PATH := $(LOCAL_PATH)/../libs/$(TARGET_ARCH_ABI)/
LOCAL_CPPFLAGS := -std=gnu++11 -Wall -fPIE -pie -fpermissive

LOCAL_SRC_FILES += JNI.cpp
ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
        LOCAL_SRC_FILES += $(ABI_ARMEABI_V7A)/qsort_ins.s
else ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
        LOCAL_SRC_FILES += $(ABI_ARM64_V8A)/qsort_ins.s
endif

LOCAL_C_INCLUDES += $(LOCAL_PATH)
LOCAL_C_INCLUDES += ${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/include
LOCAL_C_INCLUDES += ${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi-v7a/include
LOCAL_C_INCLUDES += ${ANDROID_NDK}/sources/cxx-stl/gnu-libstdc++/4.9/libs/arm64-v8a/include
LOCAL_LDLIBS := -L$(LIB_PATH) -landroid -llog -lz -lm

include $(BUILD_SHARED_LIBRARY)
