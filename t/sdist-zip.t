# Copyright © 2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

python=${PYTHON:-python}
ls distutils644.py > /dev/null || exit 1
rm -rf dist
t_eq $? 0 'initial cleanup'
$python setup.py sdist --formats=zip > /dev/null
t_eq $? 0 'sdist'
t_success 'command -v zipinfo'
zipinfo --h-t dist/distutils644-*.zip | { ! grep -v -E '^(drwxr-xr-x|-rw-r--r--|-rwxr-xr-x) '; }
t_eq $? 0 'mode'
zipinfo -v dist/distutils644-*.zip | { ! grep -w 'Unix UID'; }
t_eq $? 0 'uid, gid'
zipinfo -1 dist/distutils644-*.zip | grep -E '^[^/]+/[^/]+$' | LC_ALL=C sort -c
t_eq $? 0 'sorted #1'
zipinfo -1 dist/distutils644-*.zip | grep -E '^[^/]+/[^/]+/[^/]+$' | LC_ALL=C sort -c
t_eq $? 0 'sorted #2'
rm -rf dist
t_eq $? 0 'final cleanup'

# vim:ft=sh
