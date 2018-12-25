for srcinfo in $(ls */.SRCINFO); do
    pkgname=$(cat $srcinfo | grep pkgbase | awk '{print $3}')
    pkgver=$(cat $srcinfo | grep pkgver | awk '{print $3}')
    printf "%s %s\n" $pkgname $pkgver
done
