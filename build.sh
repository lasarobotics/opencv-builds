#!/bin/bash

#you will need to install Apache Ant, CMake and the Android SDK and NDK to build this

#set variables for Android
export ANDROID_NDK=~/Android/Sdk/ndk-bundle
export ANDROID_SDK=~/Android/Sdk
#you may need to change this for your setup

#configure!
rm -rf build
mkdir build
cd build
# -DBUILD_ANDROID_SERVICE=ON -DINSTALL_ANDROID_EXAMPLES=ON -DINSTALL_CREATE_DISTRIB=ON -DBUILD_SHARED_LIBS=ON
cmake -Wno-dev -DBUILD_TESTS=OFF -DBUILD_FAT_JAVA_LIB=ON -DBUILD_PERF_TESTS=OFF -DANDROID=ON  -DBUILD_ANDROID_EXAMPLES=OFF -DANDROID_NATIVE_API_LEVEL=16 -DOPENCV_EXTRA_MODULES_PATH=../opencv-contrib/modules -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_TOOLCHAIN_FILE=../opencv/platforms/android/android.toolchain.cmake ../opencv
#cmake -Wno-dev -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DOPENCV_EXTRA_MODULES_PATH=../opencv-contrib/modules -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_TOOLCHAIN_FILE=../opencv/platforms/android/android.toolchain.cmake ../opencv

#make!!
make -j8

#copy skeleton structure
cd ../
rm -rf sdk/
mkdir sdk/
cp -rfv skel/* sdk/

#copy OpenCV Java sources
rm -rf sdk/src/main/java/*
cp -rfv build/src/* sdk/src/main/java/
#TODO we're not copying the aidl/ folder or the manifests yet

#copy OpenCV Java SDK
rm -rfv sdk/sdk/java/src/*
cp -rfv build/src/* sdk/sdk/java/src/
#TODO we're not copying the manifests, javadocs, or manifests yet

#copy OpenCV libraries
rm -rf sdk/sdk/native/libs/*
mkdir sdk/sdk/native/libs/armeabi-v7a/
cp -rfv build/lib/armeabi-v7a/libopencv_java3.so sdk/sdk/native/libs/armeabi-v7a/

#copy OpenCV headers
rm -rf sdk/sdk/native/jni/include/* 
#TODO we're not copying the makefiles yet though
cd opencv/modules
cp -rfv */include/ ../../sdk/sdk/native/jni/

#copy OpenCV-Contrib headers
cd ../../opencv-contrib/modules
cp -rfv */include/ ../../sdk/sdk/native/jni/
cd ../../

#TODO build with Gradle, by yourself :)
#TODO we can't do much with the etc/ folder
#TODO remove the build/ dir - or not
