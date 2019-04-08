#!/bin/sh

# Copyright © 2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u

echo 1..3
python=${PYTHON:-python}
ls distutils644.py > /dev/null || exit 1
tmpdir=$(mktemp -d -t distutils644.XXXXXX)
{ $python setup.py sdist -d "$tmpdir" > /dev/null; } 2>&1
if tar -tvvf "$tmpdir"/distutils644-*.tar.gz | grep -v -E '^(drwxr-xr-x|-rw-r--r--|-rwxr-xr-x) root/root '
then
    echo not ok 1 unexpected permissions
else
    echo ok 1 644/755 permissions
fi
if tar -tf "$tmpdir"/distutils644-*.tar.gz | LC_ALL=C sort -c
then
    echo ok 2 files sorted
else
    echo not ok 2 files not sorted
fi
if zcat "$tmpdir"/distutils644-*.tar.gz | file - | grep -w 'POSIX tar archive' > /dev/null
then
    echo ok 3 POSIX tar archive
else
    echo not ok 3 unexpected tar format
fi
rm -rf "$tmpdir"

# vim:ts=4 sts=4 sw=4 et ft=sh
