#include <JNI.h>
#include <stdio.h>
#include <time.h>
#include <string>
#include <sstream>
#include <random>

using namespace std;

JavaVM* JNI::cachedJVM = NULL;
JNIEnv* JNI::Env = NULL;
jclass  JNI::gNative = NULL;

#define LOGI(fmt, args...) __android_log_print(ANDROID_LOG_INFO,  TAG, fmt, ##args)

inline
unsigned long long
getNanoTime()
{
    struct timespec t;

    t.tv_sec = 0; 
    t.tv_nsec = 0;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return static_cast<uint64_t>(t.tv_sec) * NANOSEC_PER_SEC
        + t.tv_nsec;
}

inline
const char *
ullTOstring (unsigned long long ull_val)  {
    stringstream ss;
    ss << ull_val;
    string s = ss.str();
    return s.c_str();
}

static void generateIntArrayAndSort(JNIEnv *env, jclass clazz,
        jint len) {
    int i;
    jintArray jRange = env->NewIntArray(len);
    jint *nr = env->GetIntArrayElements(jRange, NULL);
    if (nr == NULL) {
        return;
    }

    srand(time(NULL));
    for (i = 0; i < len; i++) {
        nr[i] = std::rand();
    }

    unsigned long long _start = getNanoTime();

    qsort_ins((unsigned int *)nr, len);

    unsigned long long _finish = getNanoTime();

    unsigned long long elapsed = _finish - _start;
    //LOGI("\nelapsed:      %llu\n", elapsed);
    
    std::string rezult =
        string("\nARM native quick sort evaluate.") +
        string("\nSort an array of 100 integer numbers:") +
        string("\n  start time:  ") +  
        string(ullTOstring(_start)) +
        string("\n  finish time: ") +
        string(ullTOstring(_finish)) +
        string("\n  elapsed:     ") +
        string(ullTOstring(elapsed)) +  
        string(" nanoseconds\n");

    jstring txt = env->NewStringUTF(rezult.c_str());
    if (txt) {
        jmethodID method = env->GetStaticMethodID(JNI::gNative, "passData",
            "(Ljava/lang/String;)V");
        if (method) {
            env->CallStaticVoidMethod(JNI::gNative, method, txt);
        }
        env->DeleteLocalRef(txt);
    }
}

static JNINativeMethod _methods[] = {
    { "sortIntArray", "(I)V", (void *)generateIntArrayAndSort },
};

static int registerNatives(jclass clazz) {
    JNIEnv *env = JNI::Env;
    if (env->RegisterNatives(clazz, _methods,
            sizeof(_methods) / sizeof(JNINativeMethod)) < 0) {
        LOGI("error %d register native methods failed\n", errno);
        env->DeleteLocalRef(clazz);
        return JNI_FALSE;
    }

    return JNI_TRUE;
}

JNIEXPORT
jint
JNI_OnLoad(JavaVM* jvm, void* reserved)
{
    LOGI("%s:",__FUNCTION__);

    JNI::cachedJVM = jvm;
    JNIEnv *env = NULL;

    if (jvm->GetEnv((void **)&env, JNI_VERSION_1_6) != JNI_OK) {
        LOGI("ERROR: (%s): failed to get pointer to JNI environment\n",
            __FUNCTION__);
        return JNI_ERR;
    }
    JNI::Env = env;

    jclass clazz = env->FindClass("com/hsp/q/sort/Native");
    if (!clazz) {
        return JNI_ERR;
    }

    JNI::gNative = (jclass)env->NewGlobalRef(clazz);
    if (!JNI::gNative) {
        return JNI_ERR;
    }

    if (!registerNatives(clazz)) {
        return JNI_ERR; 
    }

    env->DeleteLocalRef(clazz);

    return JNI_VERSION_1_6;
}
