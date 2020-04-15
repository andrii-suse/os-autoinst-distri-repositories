# SUSE's openQA tests
#
# Copyright © 2015-2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Configure JeOS
# Maintainer: Ciprian Cret <mnowak@suse.com>

use base "basetest";
use strict;
use warnings;
use testapi;

sub run {
    my ($self) = @_;

    assert_screen 'jeos-locale', 300;
    wait_still_screen;
    send_key 'ret', wait_screen_change => 1;
    wait_still_screen;
    send_key 'ret', wait_screen_change => 1;
    wait_still_screen;
    send_key 'ret', wait_screen_change => 1;
    wait_still_screen;

    # Enter password & Confirm
    foreach my $password_needle (qw(jeos-root-password jeos-confirm-root-password)) {
        assert_screen $password_needle;
        type_password;
        send_key 'ret';
    }
    wait_still_screen;

    assert_screen [qw(linux-login reached-power-off)], 1000;
    if (match_has_tag 'reached-power-off') {
        die "At least it reaches power off, but booting up failed, see boo#1143051. A workaround is not possible";
    }
}

sub test_flags {
    return {fatal => 1};
}

1;
