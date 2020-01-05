#ifndef QS_JNI_H
#define QS_JNI_H

#include <jni.h>
#include <errno.h>
#include "android/log.h"
#include <sys/types.h>

typedef unsigned int UInt32;

#define TAG                  "NATIVE_QS"
#define LOG_NDEBUG           1
#define NANOSEC_PER_SEC      1000000000LL

extern "C" {
    unsigned int *_qsort(unsigned int *, int);
    unsigned int *qsort_ins(unsigned int *, int);
}

class JNI {
  public:
    static JavaVM *cachedJVM;
    static JNIEnv *Env;
    static jclass gNative;
};

#endif
