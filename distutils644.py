# encoding=UTF-8

# Copyright © 2011-2017 Jakub Wilk <jwilk@jwilk.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

'''
Monkey-patch distutils to sanitize generated tarballs:
- ownership (root:root),
- permissions (0644 or 0755),
- tar format (ustar).
'''

import os
import sys
import tarfile

import distutils

if sys.version_info < (2, 7) or ((3, 0) <= sys.version_info < (3, 2)):

    import warnings
    class NotImplementedWarning(Warning, NotImplementedError):
        pass
    warnings.warn('Python %d.%d is not supported' % sys.version_info[:2], category=NotImplementedWarning, stacklevel=2)

else:

    # In Python 2.7, distutils uses the tarfile module. Let's monkey-patch it.

    original_add = tarfile.TarFile.add

    def root_filter(tarinfo):
        tarinfo.uid = tarinfo.gid = 0
        tarinfo.uname = tarinfo.gname = 'root'
        tarinfo.mode |= 0o444 | ((tarinfo.mode & 0o100) and 0o111)
        return tarinfo

    def add(self, name, arcname=None, recursive=True, exclude=None, filter=None):
        kwargs = {}
        if exclude is not None:
            kwargs.update(exclude=exclude)
        return original_add(self,
            name=name,
            arcname=arcname,
            recursive=recursive,
            filter=root_filter,
            **kwargs
        )

    tarfile.TarFile.add = add

    tarfile.TarFile.format = tarfile.USTAR_FORMAT

__all__ = []

# vim:ts=4 sts=4 sw=4 et
