#!/var/jb/usr/bin/bash

### v2.6-7 - Ultimate (All-in-One) Patcher

##Script edited by Kixrd to work with derootifier

## This Patcher does any of the following automatically:

## Theme Converter (works on arm and arm64 debs)
## Xinam1ne Patcher (rootfull to rootless)
## Reverse Patcher (rootless to rootfull)
## Auto-install option

## TURN OFF INSTALL POPUP BY ADDING ONE MORE # TO THE BEGINNING OF THE FOLLOWING LINE (2 total) LIKE SO: ##input: Install deb when.... 

##input: Install deb when finished? 'y' or 'n' ?



export TMPDIR=/var/mobile/Documents/.Xinaf1re

set -e

if ! type dpkg-deb >/dev/null 2>&1; then
    echo "Please install 'dpkg-deb'."
fi
if ! type file >/dev/null 2>&1; then
    echo "Please install 'file' from Bingner or Procursus."
fi
if ! type otool >/dev/null 2>&1 || ! type install_name_tool >/dev/null 2>&1; then
    echo "Please install 'odcctools'."
fi
if ! type plutil >/dev/null 2>&1; then
    echo "Please install 'plutil'."
fi
if ! type awk >/dev/null 2>&1; then
    echo "Please install 'gawk'."
fi
if ! type ldid >/dev/null 2>&1; then
    echo "Please install 'ldid'."
fi
if ! type dpkg-deb >/dev/null 2>&1 || ! type file >/dev/null 2>&1 || ! type otool >/dev/null 2>&1 || ! type otool >/dev/null 2>&1 || ! type plutil >/dev/null 2>&1 || ! type ldid >/dev/null 2>&1 || ! type awk >/dev/null 2>&1; then
    exit 1
fi

OLD="$(mktemp -qd)"
NEW="$(mktemp -qd)"
chmod 755 "$OLD"
chmod 755 "$NEW"

if [ ! -d "$OLD" ] || [ ! -d "$NEW" ]; then
    echo "Creating temporary directories failed."
    exit 1;
fi

### Script start
dpkg-deb -R "$1" "$OLD"
cp -a "$OLD"/DEBIAN "$NEW"

## Theme converter
if [ -d "$OLD/var/jb/Library/Themes" ] || [ -d "$OLD/Library/Themes" ]; then
if [ -d "$OLD/var/jb/Library/Themes" ]; then
    sed -i '/^Architecture: / s|iphoneos-arm64|iphoneos-arm|' "$NEW"/DEBIAN/control
    rm -rf "$OLD"/DEBIAN
    mv -f "$OLD"/var/jb/.* "$OLD"/var/jb/* "$NEW" >/dev/null 2>&1 || true
elif [ -d "$OLD/Library/Themes" ]; then
    sed -i '/^Architecture: / s|iphoneos-arm|iphoneos-arm64|' "$NEW"/DEBIAN/control
    rm -rf "$OLD"/DEBIAN
    mkdir -p "$NEW"/var/jb
    mv -f "$OLD"/.* "$OLD"/* "$NEW"/var/jb >/dev/null 2>&1 || true
fi
## Theme converter end

### Xinam1ne Patching Start
elif [ ! -d "$OLD/var/jb" ]; then
    ## Xinamine control file changes
    mkdir -p "$NEW"/var/jb
    sed 's|iphoneos-arm|iphoneos-arm64|' < "$OLD"/DEBIAN/control > "$NEW"/DEBIAN/control
    chmod -R 755 "$NEW"/DEBIAN >/dev/null 2>&1
    chmod 644 "$NEW"/DEBIAN/control >/dev/null 2>&1
    rm -rf "$OLD"/DEBIAN
    sed -i '/^Depends: / s|, xinaa15||' "$NEW"/DEBIAN/control
    sed -i '/^Depends: / s/$/, xyz.cypwn.xinam1ne/' "$NEW"/DEBIAN/control
#    sed -i '/^Version: / s/$/-xp/' "$NEW"/DEBIAN/control
    mv -f "$OLD"/.* "$OLD"/* "$NEW"/var/jb >/dev/null 2>&1 || true
    if [ -d "$NEW"/var/jb/var/mobile/Library/Designer ]; then
        mkdir -p "$NEW"/var/mobile/Library
        mv -f "$NEW"/var/jb/var/mobile/Library/Designer* "$NEW"/var/mobile/Library
        rm -rf "$NEW"/var/jb/var
    fi
    #remove xinam1ne dependency for simple debs
    if [ ! -d "$NEW"/var/jb/Library/PreferenceLoader ] && [ ! -d "$NEW"/var/jb/Library/Application\ Support ] && [ ! -d "$NEW"/var/jb/Library/PreferenceBundles ]; then
        sed -i 's|, xyz.cypwn.xinam1ne||g' "$NEW"/DEBIAN/control
    fi
    ## Xinam1ne Overall Patching Start
    find "$NEW" -type f | while read -r file; do
        if file -ib "$file" | grep -q "x-mach-binary; charset=binary"; then
            INSTALL_NAME=$(otool -D "$file" | grep -v -e ":$" -e "^Archive :" | head -n1)
            otool -L "$file" | tail -n +2 | grep -e /System | grep /Library/'[^/]'\*.dylib | cut -d' ' -f1 | tr -d "[:blank:]" > "$OLD"/._lib_cache
            if [ -n "$INSTALL_NAME" ]; then
                install_name_tool -id @rpath/"$(basename "$INSTALL_NAME")" "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q CydiaSubstrate; then
                install_name_tool -change /Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate @rpath/libsubstrate.dylib "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q CepheiPrefs.frame; then
                install_name_tool -change /Library/Frameworks/CepheiPrefs.framework/CepheiPrefs @rpath/CepheiPrefs.framework/CepheiPrefs "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q Cephei.frame; then
                install_name_tool -change /Library/Frameworks/Cephei.framework/Cephei @rpath/Cephei.framework/Cephei "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q Alderis.frame; then
                install_name_tool -change /Library/Frameworks/Alderis.framework/Alderis @rpath/Alderis.framework/Alderis "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q AltList.frame; then
                install_name_tool -change /Library/Frameworks/AltList.framework/AltList @rpath/AltList.framework/AltList "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q FLEXFramework.frame; then
                install_name_tool -change /Library/Frameworks/FLEXFramework.framework/FLEXFramework @rpath/FLEXFramework.framework/FLEXFramework "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q Orion.frame; then
                install_name_tool -change /Library/Frameworks/Orion.framework/Orion @rpath/Orion.framework/Orion "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q HyperixaKit.frame; then
                install_name_tool -change /Library/Frameworks/HyperixaKit.framework/HyperixaKit @rpath/HyperixaKit.framework/HyperixaKit "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q libhdev.frame; then
                install_name_tool -change /Library/Frameworks/libhdev.framework/libhdev @rpath/libhdev.framework/libhdev "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q libapplist.dylib; then
                install_name_tool -change /usr/lib/libapplist.dylib @rpath/libapplist.dylib "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q libcolorpicker.dylib; then
                install_name_tool -change /usr/lib/libcolorpicker.dylib @rpath/libcolorpicker.dylib "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q libCSColorPicker.dylib; then
                install_name_tool -change /usr/lib/libCSColorPicker.dylib @rpath/libCSColorPicker.dylib "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q libgcuniversal.dylib; then
                install_name_tool -change /usr/lib/libgcuniversal.dylib @rpath/libgcuniversal.dylib "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q librocketbootstrap.dylib; then
                install_name_tool -change /usr/lib/librocketbootstrap.dylib @rpath/librocketbootstrap.dylib "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q libsparkcolourpicker.dylib; then
                install_name_tool -change /usr/lib/libsparkcolourpicker.dylib @rpath/libsparkcolourpicker.dylib "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q libsparkapplist.dylib; then
                install_name_tool -change /usr/lib/libsparkapplist.dylib @rpath/libsparkapplist.dylib "$file" >/dev/null 2>&1
            fi
            if [ -f "$OLD"/._lib_cache ]; then
                cat "$OLD"/._lib_cache | while read line; do
                    install_name_tool -change "$line" @rpath/"$(basename "$line")" "$file" >/dev/null 2>&1
                done
            fi
            install_name_tool -delete_rpath "/Library/Frameworks" "$file" >/dev/null 2>&1 || true
            install_name_tool -delete_rpath "/usr/lib" "$file" >/dev/null 2>&1 || true
            install_name_tool -add_rpath "/var/jb/Library/Frameworks" "$file" >/dev/null 2>&1 || true
            install_name_tool -add_rpath "/var/jb/usr/lib" "$file" >/dev/null 2>&1 || true
            ### Xinam1ne Patch Binaries
            sed -i 's#\x00/Library#\x00/var/LIY#g' "$file"
            sed -i 's#\x00/bin/sh#\x00/var/sh#g' "$file"
            sed -i 's#\x00/usr/lib#\x00/var/lib#g' "$file"
            sed -i 's#\x00/usr/local#\x00/var/local#g' "$file"
            sed -i 's#\x00/usr/bin#\x00/var/bin#g' "$file"
            sed -i 's#\x00/private/var/mobile/Library/Preferences#\x00/private/var/jb/vmo/Library/Preferences#g' "$file"
            sed -i 's#\x00/var/mobile/Library/Preferences#\x00/var/jb/vmo/Library/Preferences#g' "$file"
            sed -i 's#\x00/var/mobile/Library/Application#\x00/var/jb/vmo/Library/Application#g' "$file"
            sed -i 's#\x00/Applications#\x00/var/jb/Xapps#g' "$file"
            sed -i 's#\x00/User/Library#\x00/var/jb/UsrLb#g' "$file"
            ## Rare occurrences with no leading slash
            sed -i 's#\x00Library/MobileSub#\x00var/LIY/MobileSub#g' "$file"
            sed -i 's#\x00Library/dpkg#\x00var/lib/dpkg#g' "$file"
            sed -i 's#\x00Library/Sn#\x00var/LIY/Sn#g' "$file"
            sed -i 's#\x00Library/Th#\x00var/LIY/Th#g' "$file"
            sed -i 's#\x00Library/Application#\x00var/LIY/Application#g' "$file"
            sed -i 's#\x00Library/LaunchD#\x00var/LIY/LaunchD#g' "$file"
            sed -i 's#\x00Library/PreferenceB#\x00var/LIY/PreferenceB#g' "$file"
            sed -i 's#\x00Library/PreferenceL#\x00var/LIY/PreferenceL#g' "$file"
            sed -i 's#\x00Library/Frameworks#\x00var/LIY/Frameworks#g' "$file"
            sed -i 's#\x00bin/sh#\x00var/sh#g' "$file"
            sed -i 's#\x00usr/lib#\x00var/lib#g' "$file"
            sed -i 's#\x00usr/local#\x00var/local#g' "$file"
            sed -i 's#\x00usr/bin#\x00var/bin#g' "$file"
            sed -i 's#\x00private/var/mobile/Library/Preferences#\x00private/var/jb/vmo/Library/Preferences#g' "$file"
            sed -i 's#\x00var/mobile/Library/Preferences#\x00var/jb/vmo/Library/Preferences#g' "$file"
            sed -i 's#/var/mobile/Library/Preferences#/var/jb/vmo/Library/Preferences#g' "$file"
            sed -i 's#\x00var/mobile/Library/Application#\x00var/jb/vmo/Library/Application#g' "$file"
            sed -i 's#\x00Applications#\x00var/jb/Xapps#g' "$file"
            sed -i 's#\x00User/Library#\x00var/jb/UsrLb#g' "$file"
            ## Tweak-specific rare occurrences 
            sed -i 's#\x00Library/Act#\x00var/LIY/Act#g' "$file"
            sed -i 's#\x00Library/Flip#\x00var/LIY/Flip#g' "$file"
            sed -i 's#\x00Library/Switch#\x00var/LIY/Switch#g' "$file"
            sed -i 's#\x00Library/Hyp#\x00var/LIY/Hyp#g' "$file"
            sed -i 's#\x00Library/OH#\x00var/LIY/OH#g' "$file"
            sed -i 's#\x00Library/Emer#\x00var/LIY/Emer#g' "$file"
            sed -i 's#\x00Library/Har#\x00var/LIY/Har#g' "$file"
            sed -i 's#\x00Library/Spec#\x00var/LIY/Spec#g' "$file"
            sed -i 's#\x00Library/Cyl#\x00var/LIY/Cyl#g' "$file"
            sed -i 's#\x00Library/Jarv#\x00var/LIY/Jarv#g' "$file"
            sed -i 's#\x00Library/AhAh#\x00var/LIY/AhAh#g' "$file"
            sed -i 's#\x00Library/Tweak S#\x00var/LIY/Tweak S#g' "$file"
            ## End Tweak-specific rare occurrences
            ## END Rare occurrences

            ## Revert Exceptions
            sed -i 's#\x00/var/lib/libobjc.A.dylib#\x00/usr/lib/libobjc.A.dylib#g' "$file"
            sed -i 's#\x00/var/lib/libc++.1.dylib#\x00/usr/lib/libc++.1.dylib#g' "$file"
            sed -i 's#\x00/var/lib/libSystem.B.dylib#\x00/usr/lib/libSystem.B.dylib#g' "$file"
            sed -i 's#\x00/var/lib/libstdc++.6.dylib#\x00/usr/lib/libstdc++.6.dylib#g' "$file"
            sed -i 's#\x00/var/lib/libMobileGestalt.dylib#\x00/usr/lib/libMobileGestalt.dylib#g' "$file"
            sed -i 's#\x00/var/lib/system/#\x00/usr/lib/system/#g' "$file"
            sed -i 's#\x00/var/lib/dyld#\x00/usr/lib/dyld#g' "$file"
            sed -i 's#\x00/var/lib/swift#\x00/usr/lib/swift#g' "$file"
            sed -i 's#\x00/var/lib/libswift#\x00/usr/lib/libswift#g' "$file"
            sed -i 's#\x00/var/lib/libsql#\x00/usr/lib/libsql#g' "$file"
            sed -i 's#\x00/var/lib/libz#\x00/usr/lib/libz#g' "$file"
            ldid -S "$file"
        ## Xinam1ne Patch .plist files
        elif basename "$file" | grep -q ".plist"; then
            plutil -convert xml1 "$file" >/dev/null 2>&1
            sed -i 's#>/Applications/#>/var/jb/Applications/#g' "$file"
            sed -i 's#>/Library/i#>/var/LIY/i#g' "$file"
            sed -i 's#>/usr/share/#>/var/share/#g' "$file"
            sed -i 's#>/usr/bin/#>/var/bin/#g' "$file"
            sed -i 's#>/usr/lib/#>/var/lib/#g' "$file"
            sed -i 's#>/usr/sbin/#>/var/sbin/#g' "$file"
            sed -i 's#>/usr/libexec/#>/var/libexec/#g' "$file"
            sed -i 's#>/usr/local/#>/var/local/#g' "$file"
            sed -i 's#>/usr/#>/var/jb/usr/#g' "$file"
            sed -i 's#>/etc/#>/var/etc/#g' "$file"
            sed -i 's#>/bin/#>/var/bin/#g' "$file"
            sed -i 's#>/Library/#>/var/LIY/#g' "$file"
            sed -i 's#>/var/mobile/Library/Pref#>/var/jb/var/mobile/Library/Pref/#g' "$file"
        fi
    done
    ## Patch /DEBIAN preinst, postinst, prerm, postrm
    find "$NEW"/DEBIAN -type f | while read -r file; do
        if basename "$file" | grep -vq "control" && file -ib "$file" | grep -vq "x-mach-binary; charset=binary"; then
            sed -i 's#\[:space:]##g' "$file"
            sed -i 's#\[]#\\ #g' "$file"
            sed -i 's# /Applications/# /var/jb/Applications/#g' "$file"
            sed -i 's# /Library/i# /var/LIY/i#g' "$file"
            sed -i 's# /usr/share/# /var/share/#g' "$file"
            sed -i 's# /usr/bin/# /var/bin/#g' "$file"
            sed -i 's# /usr/lib/# /var/lib/#g' "$file"
            sed -i 's#/usr/sbin/#/var/sbin/#g' "$file"
            sed -i 's#/usr/libexec/#/var/libexec/#g' "$file"
            sed -i 's#/usr/local/#/var/local/#g' "$file"
            sed -i 's# /usr/# /var/jb/usr/#g' "$file"
            sed -i 's# /etc/# /var/etc/#g' "$file"
            sed -i 's# /bin/# /var/bin/#g' "$file"
            sed -i 's# /Library/# /var/LIY/#g' "$file"
            sed -i 's# "/Applications/# "/var/jb/Applications/#g' "$file"
            sed -i 's# "/Library/i# "/var/LIY/i#g' "$file"
            sed -i 's# "/usr/share/# "/var/share/#g' "$file"
            sed -i 's# "/usr/bin/# "/var/bin/#g' "$file"
            sed -i 's# "/usr/lib/# "/var/lib/#g' "$file"
            sed -i 's#"/usr/sbin/#"/var/sbin/#g' "$file"
            sed -i 's#"/usr/libexec/#"/var/libexec/#g' "$file"
            sed -i 's#"/usr/local/#"/var/local/#g' "$file"
            sed -i 's# "/usr/# "/var/jb/usr/#g' "$file"
            sed -i 's# "/etc/# "/var/etc/#g' "$file"
            sed -i 's# "/bin/# "/var/bin/#g' "$file"
            sed -i 's# "/Library/# "/var/LIY/#g' "$file"
            ## shebang handler
            bangsh="#!/bin/sh"
            bangbash="#!/bin/bash"
            ## Check if the first line contains a shebang
            if [ "$(head -c 2 "$file")" = "#!" ]; then
                if [ "$(head -c 2 "$file")" = "/sh" ]; then
                    ## Replace sh shebang with new sh shebang
                    sed -i '1s|.*|'"$bangsh"'|' "$file"
                else
                    ## Replace existing shebang with new bash shebang
                    sed -i '1s|.*|'"$bangbash"'|' "$file"
                fi
            else
                ## Add new bash shebang as the first line
                sed -i '1s|^|'"$bangbash"'\n\n|' "$file"
            fi
            ## end shebang handler
        fi
    done
    ### Xinam1ne Patching End

### Rootless to Rootful Patching Start
elif [ -d "$OLD/var/jb" ]; then
    ## Rootless to Rootfull control file changes
#    sed -i '/^Package: / s/$/rootless/' "$OLD"/DEBIAN/control  ## adds "rootless" to end of Package line
#    sed -i '/^Name: / s/$/ (rootless)/' "$OLD"/DEBIAN/control ## adds " (rootless)" to end of Name line
    sed -i '/^Package: / s|-rootless||' "$OLD"/DEBIAN/control
    sed -i '/^Package: / s|-Rootless||' "$OLD"/DEBIAN/control
    sed -i '/^Package: / s|rootless||' "$OLD"/DEBIAN/control
    sed -i '/^Package: / s|Rootless||' "$OLD"/DEBIAN/control
    sed -i '/^Name: / s| (rootless)||' "$OLD"/DEBIAN/control
    sed -i '/^Name: / s| (Rootless)||' "$OLD"/DEBIAN/control
    sed -i '/^Depends: / s|, xyz.cypwn.xinam1ne||' "$OLD"/DEBIAN/control
    sed -i '/^Depends: / s|firmware (>=15|firmware (>=14|' "$OLD"/DEBIAN/control
    sed -i '/^Depends: / s|firmware (>= 15|firmware (>= 14|' "$OLD"/DEBIAN/control
    sed '/^Architecture: / s|iphoneos-arm64|iphoneos-arm|' < "$OLD"/DEBIAN/control > "$NEW"/DEBIAN/control
#    sed 's|iphoneos-arm64|iphoneos-arm|' < "$OLD"/DEBIAN/control > "$NEW"/DEBIAN/control
    rm -rf "$OLD"/DEBIAN
    mv -f "$OLD"/.* "$OLD"/* "$NEW" >/dev/null 2>&1 || true
    ## Rootless to Rootfull Overall Patching Start
    find "$NEW" -type f | while read -r file; do
        if file -ib "$file" | grep -q "x-mach-binary; charset=binary"; then
#            echo "$file"
            INSTALL_NAME=$(otool -D "$file" | grep -v -e ":$" -e "^Archive :" | head -n1)
            otool -L "$file" | tail -n +2 | grep -e /System | grep /Library/'[^/]'\*.dylib | cut -d' ' -f1 | tr -d "[:blank:]" > "$OLD"/._lib_cache
            if [ -n "$INSTALL_NAME" ]; then
                install_name_tool -id @rpath/"$(basename "$INSTALL_NAME")" "$file" >/dev/null 2>&1
            fi
            if otool -L "$file" | grep -q CydiaSubstrate; then
                install_name_tool -change @rpath/CydiaSubstrate.framework/CydiaSubstrate @rpath/libsubstrate.dylib "$file" >/dev/null 2>&1
            fi
            if [ -f "$OLD"/._lib_cache ]; then
                cat "$OLD"/._lib_cache | while read line; do
                install_name_tool -change "$line" @rpath/"$(basename "$line")" "$file" >/dev/null 2>&1
                done
            fi
            install_name_tool -delete_rpath "/var/jb/Library/Frameworks" "$file" >/dev/null 2>&1 || true
            install_name_tool -delete_rpath "/var/jb/usr/lib" "$file" >/dev/null 2>&1 || true
            install_name_tool -add_rpath "/Library/Frameworks" "$file" >/dev/null 2>&1 || true
            install_name_tool -add_rpath "/usr/lib" "$file" >/dev/null 2>&1 || true
            ### Rootless to Rootfull Patch Binaries
            sed -i 's#\x00/var/jb/Library/MobileSubstrate#\x00/Library/MobileSubstrate///////#g' "$file"
            sed -i 's#\x00/var/jb/Library/PreferenceBundles#\x00/Library/PreferenceBundles///////#g' "$file"
            sed -i 's#\x00/var/jb/Library/PreferenceLoader#\x00/Library/PreferenceLoader///////#g' "$file"
            sed -i 's#\x00/var/jb/var/mobile/Library/Preferences#\x00/var/mobile/Library/Preferences///////#g' "$file"
            sed -i 's#\x00/var/jb/Library/Application Support#\x00/Library/Application Support///////#g' "$file"
            sed -i 's#\x00/var/jb/Applications#\x00/Applications///////#g' "$file"
            sed -i 's#\x00/var/jb\x00#\x00///////\x00#g' "$file"
            sed -i 's#\x00/var/jb/usr/bin#\x00/usr/bin///////#g' "$file"
            sed -i 's#\x00/var/jb/usr/lib/#\x00/usr/lib////////#g' "$file"
            sed -i 's#\x00/var/jb/usr/sbin#\x00/usr/sbin///////#g' "$file"
            sed -i 's#\x00/var/jb/sbin#\x00/usr/sbin///#g' "$file"
            sed -i 's#\x00/var/jb/usr/local/bin#\x00/usr/local/bin///////#g' "$file"
            sed -i 's#\x00/var/jb/usr/libexec#\x00/usr/libexec///////#g' "$file"
            sed -i 's#\x00/var/jb/usr/local#\x00/usr/local/////////#g' "$file"
            sed -i 's#\x00/var/jb/User/Library/Preferences#\x00/var/mobile/Library/Preferences/#g' "$file"
            sed -i 's#/var/jb/vmo/Library/Preferences#/var/mobile/Library/Preferences#g' "$file"
            sed -i 's#\x00/var/jb#\x00///////#g' "$file"
            sed -i 's#\x00/var/LIY#\x00/Library#g' "$file"
            sed -i 's#\x00var/LIY#\x00Library#g' "$file"
            sed -i 's#var/LIY#Library#g' "$file"
            sed -i 's#var/bin#usr/bin#g' "$file"

            ldid -S "$file"
        ## Rootless to Rootfull Patch .plist files
        elif basename "$file" | grep -q ".plist"; then
            plutil -convert xml1 "$file" >/dev/null 2>&1
            sed -i 's#>/var/jb/Applications/#>/Applications/#g' "$file"
            sed -i 's#>/var/jb/Library/i#>/Library/i#g' "$file"
            sed -i 's#>/var/jb/usr/share/#>/usr/share/#g' "$file"
            sed -i 's#>/var/jb/usr/bin/#>/usr/bin/#g' "$file"
            sed -i 's#>/var/jb/usr/lib/#>/usr/lib/#g' "$file"
            sed -i 's#>/var/jb/usr/sbin/#>/usr/sbin/#g' "$file"
            sed -i 's#>/var/jb/usr/libexec/#>/usr/libexec/#g' "$file"
            sed -i 's#>/var/jb/usr/local/#>/usr/local/#g' "$file"
            sed -i 's#>/var/jb/usr/#>/usr/#g' "$file"
            sed -i 's#>/var/jb/etc/#>/etc/#g' "$file"
            sed -i 's#>/var/jb/bin/#>/bin/#g' "$file"
            sed -i 's#>/var/jb/Library/#>/Library/#g' "$file"
            sed -i 's#>/var/jb/var/mobile/Library/Pref#>/var/mobile/Library/Pref/#g' "$file"
            sed -i 's#>/var/jb/#>/#g' "$file"
            sed -i 's#>/var/LIY/#>/Library/#g' "$file"
            sed -i 's#>/var/share/#>/usr/share/#g' "$file"
            sed -i 's#>/var/sbin/#>/usr/sbin/#g' "$file"
            sed -i 's#>/var/libexec/#>/usr/libexec/#g' "$file"
            sed -i 's#>/var/local/#>/usr/local/#g' "$file"
            sed -i 's#>/var/etc/#>/etc/#g' "$file"
            sed -i 's#>/var/jb/vmo/Library/Pref#>/var/mobile/Library/Pref/#g' "$file"
        fi
    done
    mkdir -p "$NEW"/temp
    mv -f "$NEW"/var/jb/.* "$NEW"/var/jb/* "$NEW"/temp >/dev/null 2>&1 || true
    rm -rf "$NEW"/var/jb
    if [ -d "$NEW"/temp/var/jb/usr/lib/TweakInject ]; then
        mkdir -p "$NEW"/temp/var/jb/Library/MobileSubstrate
        mv "$NEW"/temp/var/jb/usr/lib/TweakInject "$NEW"/temp/var/jb/Library/MobileSubstrate/DynamicLibraries
        rm -rf "$NEW"/temp/var/jb/usr/lib/TweakInject
    fi
    if [ -d "$NEW"/temp/var/jb/usr/lib ]; then
        [ "$(ls -A "$NEW"/temp/var/jb/usr/lib)" ] && : || rm -rf "$NEW"/temp/var/jb/usr/lib
    fi
    if [ -d "$NEW"/temp/var/jb/usr ]; then
        [ "$(ls -A "$NEW"/temp/var/jb/usr)" ] && : || rm -rf "$NEW"/temp/var/jb/usr
    fi
    mv -f "$NEW"/temp/var/jb/.* "$NEW"/temp/var/jb/* "$NEW" >/dev/null 2>&1 || true
    rm -rf "$NEW"/temp/var/jb
    [ -d "$NEW"/var ] && [ "$(ls -A "$NEW"/var)" ] && : || rm -rf "$NEW"/var
    mv -f "$NEW"/temp/.* "$NEW"/temp/* "$NEW" >/dev/null 2>&1 || true
    rm -rf "$NEW"/temp
    ## Rootless to Rootfull Patch /DEBIAN preinst, postinst, prerm, postrm
    find "$NEW"/DEBIAN -type f | while read -r file; do
        if basename "$file" | grep -vq "control" && file -ib "$file" | grep -vq "x-mach-binary; charset=binary"; then
            sed -i 's#/var/jb##g' "$file"
            sed -i 's#\[:space:]##g' "$file"
            sed -i 's#\[]#\\ #g' "$file"
            sed -i 's# /var/jb/Applications/# /Applications/#g' "$file"
            sed -i 's# /var/LIY/i# /Library/i#g' "$file"
            sed -i 's# /var/share/# /usr/share/#g' "$file"
            sed -i 's# /var/bin/# /usr/bin/#g' "$file"
            sed -i 's# /var/lib/# /usr/lib/#g' "$file"
            sed -i 's#/var/sbin/#/usr/sbin/#g' "$file"
            sed -i 's#/var/libexec/#/usr/libexec/#g' "$file"
            sed -i 's#/var/local/#/usr/local/#g' "$file"
            sed -i 's# /var/jb/usr/# /usr/#g' "$file"
            sed -i 's# /var/etc/# /etc/#g' "$file"
            sed -i 's# /var/bin/# /bin/#g' "$file"
            sed -i 's# /var/LIY/# /Library/#g' "$file"
            sed -i 's# "/var/jb/Applications/# "/Applications/#g' "$file"
            sed -i 's# "/var/LIY/i# "/Library/i#g' "$file"
            sed -i 's# "/usr/share/# "/var/share/#g' "$file"
            sed -i 's# "/var/bin/# "/usr/bin/#g' "$file"
            sed -i 's# "/var/lib/# "/usr/lib/#g' "$file"
            sed -i 's#"/var/sbin/#"/usr/sbin/#g' "$file"
            sed -i 's#"/var/libexec/#"/usr/libexec/#g' "$file"
            sed -i 's#"/var/local/#"/usr/local/#g' "$file"
            sed -i 's# "/var/jb/usr/# "/usr/#g' "$file"
            sed -i 's# "/var/etc/# "/etc/#g' "$file"
            sed -i 's# "/var/bin/# "/bin/#g' "$file"
            sed -i 's# "/var/LIY/# "/Library/#g' "$file"
            ## shebang handler
            bangsh="#!/bin/sh"
            bangbash="#!/bin/bash"
            ## Check if the first line contains a shebang
            if [ "$(head -c 2 "$file")" = "#!" ]; then
                if [ "$(head -c 2 "$file")" = "/sh" ]; then
                    ## Replace sh shebang with new sh shebang
                    sed -i '1s|.*|'"$bangsh"'|' "$file"
                else
                    ## Replace existing shebang with new bash shebang
                    sed -i '1s|.*|'"$bangbash"'|' "$file"
                fi
            else
                ## Add new bash shebang as the first line
                sed -i '1s|^|'"$bangbash"'\n\n|' "$file"
            fi
            ## end shebang handler
        fi
    done
    ### Rootless to Rootful Patching End
fi
### Script end
/var/jb/usr/local/bin/Xinam1ne 2> /dev/null

## Popup checker
if [ ! -z $3 ]; then
    while true; do
    case $3 in
                        [Yy]* ) yn=y;
                        break;;
                        [Nn]* ) yn=n;
                        break;;
                        * ) echo "Please answer yes or no."};
    esac
    done

    ## redeb only (no install) if No was chosen in popup
    if [ $yn = "n" ]; then
        dpkg-deb -b "$NEW" "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb >/dev/null 2>&1
        chown 501:501 "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb >/dev/null 2>&1
    ## redeb with error checker if Yes was chosen in popup
    elif [ $yn = "y" ]; then
        dpkg-deb -b "$NEW" "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb
        chown 501:501 "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb >/dev/null 2>&1
        ## Install deb if previous line redeb is successful
        if [ $? -eq 0 ]; then
            if [ -d "$NEW/var/Themes" ]; then
                dpkg -i "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb 2> /dev/null
                echo "Done."
            else
                dpkg -i "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb
                echo "Done."
            fi
        fi
    fi
else
    ##Default redeb only if Yes/No popup is disabled
    dpkg-deb -b "$NEW" "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb >/dev/null 2>&1
    chown 501:501 "/var/mobile/Documents/.Xinaf1re"/"$(grep Package: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Version: "$NEW"/DEBIAN/control | cut -f2 -d ' ')"_"$(grep Architecture: "$NEW"/DEBIAN/control | cut -f2 -d ' ')".deb >/dev/null 2>&1
fi

## Cleaning up
rm -rf "$OLD" "$NEW"
