# Copyright © 2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

.PHONY: all install
all install:
	$(error Use setup.py for building and installing.)

.PHONY: test
test:
	env SHOVE_WORK_DIR="$$PWD/.shove" shove -r t -v

# vim:ts=4 sts=4 sw=4 noet
