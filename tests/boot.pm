# Copyright (C) 2014-2018 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

use base 'basetest';
use strict;
use testapi;

sub run {
    my $self = shift;

    # JeOS images GRUB2 timeout is set to 10s
    my $counter = -1;
    do {
        send_key 'home' for (1 .. 3);
        $counter++;
    } while ((!check_screen('grub2', 1)) && ($counter < 10));
    assert_screen "grub2", 10;
    send_key 'ret';
    sleep(1);
    save_screenshot;
}

sub test_flags {
    return {fatal => 1};
}

1;
