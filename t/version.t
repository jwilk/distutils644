# Copyright © 2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

python=${PYTHON:-python}
ls distutils644.py > /dev/null || exit 1
setup_version=$($python setup.py --version)
t_eq $? 0 'setup.py version'
mod_version=$($python -c 'import distutils644 as d; print(d.__version__)')
t_eq $? 0 'module version'
t_is "$setup_version" "$mod_version" 'both versions equal'

# vim:ft=sh
