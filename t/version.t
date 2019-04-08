#!/bin/sh

# Copyright © 2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

set -e -u

echo 1..1
python=${PYTHON:-python}
ls distutils644.py > /dev/null || exit 1
setup_version=$($python setup.py --version)
echo "# setup version = $setup_version"
mod_version=$($python -c 'import distutils644 as d; print(d.__version__)')
echo "# module version = $mod_version"
if [ "$setup_version" = "$mod_version" ]
then
    echo ok 1 consistent versions
else
    echo not ok 1 inconsistent versions
fi

# vim:ts=4 sts=4 sw=4 et ft=sh
