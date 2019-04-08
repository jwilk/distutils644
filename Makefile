# Copyright © 2018-2019 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

.PHONY: all install
all install:
	$(error Use setup.py for building and installing.)

.PHONY: test
test:
	prove -v

.PHONY: clean
clean: ;

.error = GNU make is required

# vim:ts=4 sts=4 sw=4 noet
