for dir in $(find . -type d -maxdepth 1); do
    pushd "$dir"
    test -f PKGBUILD && makepkg --printsrcinfo > .SRCINFO
    popd
done
