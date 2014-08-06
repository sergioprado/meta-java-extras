do_install() {
    install -d ${D}${libdir_jvm}
    cp -R ${WORKDIR}/${ICEDTEA}/build/${BUILD_DIR}/j2sdk-image ${D}${JDK_HOME}

    chmod u+rw -R ${D}${JDK_HOME}

    # Fix symlink which would point into staging in the binary package.
    ln -sf ${datadir_java}/rhino.jar ${D}${JDK_HOME}/jre/lib/rhino.jar

    # JRE is a subset of JDK. So to save space and resemble what the BIG distros
    # do we create symlinks from the JDK binaries to their counterparts in the
    # JRE folder (which have to exist by that time b/c of dependencies).
    for F in `find ${D}${JDK_HOME}/jre/bin -type f`
    do
        bf=`basename $F`
        bbnote "replace:" $bf
        rm ${D}${JDK_HOME}/bin/$bf
        ln -s ${JDK_HOME}/jre/bin/$bf ${D}${JDK_HOME}/bin/$bf
    done

        install -m644 ${WORKDIR}/jvm.cfg  ${D}${JDK_HOME}/jre/lib/${JDK_ARCH}/
        # workaround for shared libarary searching
    ln -sf ${JDK_HOME}/jre/lib/${JDK_ARCH}/server/libjvm.so ${D}${JDK_HOME}/jre/lib/${JDK_ARCH}/
}

require openjdk-postinst-fixes.inc
