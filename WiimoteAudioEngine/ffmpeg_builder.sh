#!/bin/sh

# ffmpeg_builder.sh
#
# Created by alxn1 on 07.08.12.
# Copyright 2012 alxn1. All rights reserved.

ffmpeg_svn_url="svn://svn.ffmpeg.org/ffmpeg/trunk"
ffmpeg_src_path="ffmpeg_src"
ffmpeg_build_root_path="build_root"
ffmpeg_result_path="ffmpeg"

function fix_apple_sdk()
{
    local original_file="/Developer/SDKs/MacOSX10.5.sdk/usr/lib/crt1.10.5.o"
    local missed_file="/Developer/SDKs/MacOSX10.5.sdk/usr/lib/crt1.10.6.o"

    if([[ ! -f "$missed_file" ]]) then
        ln -s "$original_file" "$missed_file"
        return $?
    fi

    return 0
}

function cleanup()
{
    rm -Rf "$ffmpeg_src_path"
    rm -Rf "$ffmpeg_build_root_path"
    rm -Rf "$ffmpeg_result_path"
    return 0
}

function checkout_ffmpeg()
{
    svn checkout "$ffmpeg_svn_url" "$ffmpeg_src_path"
    return $?
}

function configure_sources()
{
    local arch="$1"

    cd "$ffmpeg_src_path"

    CFLAGS="-isysroot /Developer/SDKs/MacOSX10.5.sdk -arch $arch" \
    CXXFLAGS="-isysroot /Developer/SDKs/MacOSX10.5.sdk -arch $arch" \
    CPPFLAGS="-isysroot /Developer/SDKs/MacOSX10.5.sdk -arch $arch" \
    LDFLAGS="-isysroot /Developer/SDKs/MacOSX10.5.sdk -arch $arch" \
	./configure \
        --disable-static \
		--enable-shared \
		--enable-runtime-cpudetect \
		--enable-mmx \
		--enable-mmx2 \
		--enable-sse \
		--enable-ssse3 \
        --disable-yasm \
		--prefix="../$ffmpeg_build_root_path/$arch"

    local result=$?

    cd ..
    return $result
}

function make_sources()
{
    cd "$ffmpeg_src_path"

    make
    make install

    local result=$?

    make clean
    cd ..

    return $result
}

function remove_sources()
{
    rm -Rf "$ffmpeg_src_path"
    return $?
}

function create_result_path()
{
    mkdir "$ffmpeg_result_path"
    return $?
}

function copy_ffmpeg_headers()
{
    cp -Rf "$ffmpeg_build_root_path/i386/include" "$ffmpeg_result_path/"
    return $?
}

function remove_trash_from_libs()
{
    local arch="$1"

    cd "$ffmpeg_build_root_path/$arch/lib"
    find . -type l -delete
    find . -type d -exec rm -Rf {} \;
    cd ../../../

    return 0
}

function rename_libs()
{
    local arch="$1"

    cd "$ffmpeg_build_root_path/$arch/lib"
    mv libavcodec*.dylib libavcodec.dylib
    mv libavcore*.dylib libavcore.dylib
    mv libavdevice*.dylib libavdevice.dylib
    mv libavfilter*.dylib libavfilter.dylib
    mv libavformat*.dylib libavformat.dylib
    mv libavutil*.dylib libavutil.dylib
    mv libswscale*.dylib libswscale.dylib
    rm -Rf ./lib*.*.dylib
    cd ../../../

    return 0
}

function fix_lib_install_names()
{
    local lib="$1"
    local arch="$2"

    install_name_tool -change "../$ffmpeg_build_root_path/$arch/lib/libavcodec.dylib" "@loader_path/libavcodec.dylib" "$lib"
    install_name_tool -change "../$ffmpeg_build_root_path/$arch/lib/libavcore.dylib" "@loader_path/libavcore.dylib" "$lib"
    install_name_tool -change "../$ffmpeg_build_root_path/$arch/lib/libavdevice.dylib" "@loader_path/libavdevice.dylib" "$lib"
    install_name_tool -change "../$ffmpeg_build_root_path/$arch/lib/libavfilter.dylib" "@loader_path/libavfilter.dylib" "$lib"
    install_name_tool -change "../$ffmpeg_build_root_path/$arch/lib/libavformat.dylib" "@loader_path/libavformat.dylib" "$lib"
    install_name_tool -change "../$ffmpeg_build_root_path/$arch/lib/libavutil.dylib" "@loader_path/libavutil.dylib" "$lib"
    install_name_tool -change "../$ffmpeg_build_root_path/$arch/lib/libswscale.dylib" "@loader_path/libswscale.dylib" "$lib"
    install_name_tool -id "@loader_path/$lib" "$lib"

    return 0
}

function fix_libs_install_names()
{
    local arch="$1"

    cd "$ffmpeg_build_root_path/$arch/lib"
    fix_lib_install_names "libavcodec.dylib" "$arch"
    fix_lib_install_names "libavcore.dylib" "$arch"
    fix_lib_install_names "libavdevice.dylib" "$arch"
    fix_lib_install_names "libavfilter.dylib" "$arch"
    fix_lib_install_names "libavformat.dylib" "$arch"
    fix_lib_install_names "libavutil.dylib" "$arch"
    fix_lib_install_names "libswscale.dylib" "$arch"
    cd ../../../

    return 0
}

function create_result_lib_path()
{
    mkdir "$ffmpeg_result_path/lib"
    return $?
}

function make_universal_lib()
{
    local lib="$1"

    lipo "$ffmpeg_build_root_path/i386/lib/$lib" "$ffmpeg_build_root_path/x86_64/lib/$lib" -create -output "$ffmpeg_result_path/lib/$lib"
}

function make_universal_libs()
{
    make_universal_lib "libavcodec.dylib"
    make_universal_lib "libavcore.dylib"
    make_universal_lib "libavdevice.dylib"
    make_universal_lib "libavfilter.dylib"
    make_universal_lib "libavformat.dylib"
    make_universal_lib "libavutil.dylib"
    make_universal_lib "libswscale.dylib"

    return 0
}

function remove_build_root()
{
    rm -Rf "$ffmpeg_build_root_path"
}

# fix_apple_sdk &&

cleanup &&
checkout_ffmpeg &&
configure_sources "i386" &&
make_sources &&
configure_sources "x86_64" &&
make_sources &&
remove_sources &&
create_result_path &&
copy_ffmpeg_headers &&
remove_trash_from_libs "i386" &&
remove_trash_from_libs "x86_64" &&
rename_libs "i386" &&
rename_libs "x86_64" &&
fix_libs_install_names "i386" &&
fix_libs_install_names "x86_64" &&
create_result_lib_path &&
make_universal_libs &&
remove_build_root
