# Copyright (C) 2020 SUSE LLC
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

sub test_repoblender {
    my $project    = get_required_var('PROJECT');
    my $repository = get_required_var('REPOSITORY');
    my $configure = <<"EOF";
zypper -n in git-core wget tar m4
cd /
mkdir /testing
EOF
    assert_script_run($_, timeout => 400) foreach (split /\n/, $configure);

    $configure = <<"EOL";
setfacl -d -m g::rx /testing
setfacl -d -m o::rx /testing
setfacl -m g::r /testing
setfacl -m o::r /testing
cd /testing
chmod 755 /testing
ls -la
git clone https://github.com/andrii-suse/repoblender
ls -la
cd repoblender
scripts/setup_repo_environ.sh $project $repository
EOL
    assert_script_run($_, timeout => 800) foreach (split /\n/, $configure);
    wait_still_screen;
    save_screenshot;
}

sub run {
    send_key "ctrl-alt-f3";
    assert_screen "linux-login";
    type_string "root\n";
    assert_screen "password-prompt";
    type_string $testapi::password . "\n";
    wait_still_screen(2);
    diag('Ensure packagekit is not interfering with zypper calls');
    script_run('systemctl stop packagekit.service; systemctl mask packagekit.service');
    test_repoblender;
    save_screenshot;
    type_string "clear\n";
}

1;
