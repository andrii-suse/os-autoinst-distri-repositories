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

sub test_repoblender_environs {
    my $project    = get_required_var('PROJECT');
    my $repository = get_required_var('REPOSITORY');
    
    my $environs_test  = <<"EOL";
git clone https://github.com/andrii-suse/environs environs
sed -i 's,install --from \$proj,install --allow-vendor-change,' environs/.product/mb/system/.install.sh
[ ! -f $project/$repository/test-environs.sh ] || zypper -n in sudo
set -o pipefail
[ ! -f $project/$repository/test-environs.sh ] || $project/$repository/test-environs.sh | tee test-environs.log
EOL
    assert_script_run($_, timeout => 600) foreach (split /\n/, $environs_test);
    upload_logs("test-environs.log");
    wait_still_screen;
    save_screenshot;
}

sub run {
    wait_still_screen(2);
    test_repoblender_environs;
    save_screenshot;
    upload_logs("test-environs.log");
    upload_logs("/var/log/apache2/error_log");

    type_string "clear\n";
}

sub post_fail_hook {
    upload_logs("test-environs.log");
    upload_logs("/var/log/apache2/error_log");
}

1;
