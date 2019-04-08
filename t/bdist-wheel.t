#!/bin/sh

# Copyright © 2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u

python=${PYTHON:-python}
ls distutils644.py > /dev/null || exit 1
if command -v zipinfo > /dev/null
then
    echo 1..2
else
    echo 1..0 SKIP 'zipinfo(1) not found'
    exit
fi
tmpdir=$(mktemp -d -t distutils644.XXXXXX)
{ $python setup.py bdist_wheel -d "$tmpdir" > /dev/null; } 2>&1
if zipinfo --h-t "$tmpdir"/distutils644-*.whl | { ! grep -v -E '^(drwxr-xr-x|-rw-r--r--|-rwxr-xr-x) '; }
then
    echo ok 1 644/755 permissions
else
    echo not ok 1 unexpected permissions
fi
if zipinfo -v "$tmpdir"/distutils644-*.whl | { ! grep -w 'Unix UID'; }
then
    echo ok 2 no UNIX UIDs
else
    echo not ok 2 unexpected UNIX UIDs
fi
rm -rf "$tmpdir"

# vim:ts=4 sts=4 sw=4 et ft=sh
