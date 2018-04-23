# Copyright © 2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

python=${PYTHON:-python}
ls distutils644.py > /dev/null || exit 1
rm -rf dist
t_eq $? 0 'initial cleanup'
$python setup.py sdist > /dev/null
t_eq $? 0 'sdist'
tar -tvvf dist/distutils644-*.tar.gz | { ! grep -v -E '^(drwxr-xr-x|-rw-r--r--|-rwxr-xr-x) root/root '; }
t_eq $? 0 'uid, gid, mode'
tar -tf dist/distutils644-*.tar.gz | LC_ALL=C sort -c
t_eq $? 0 'sorted'
zcat dist/distutils644-*.tar.gz | file - | grep -w 'POSIX tar archive' > /dev/null
t_eq $? 0 'tar format'
rm -rf dist
t_eq $? 0 'final cleanup'

# vim:ft=sh
