#!/usr/bin/perl

#      Copyright (C) 2019 Jan-Luca Neumann
#      https://github.com/sunsettrack4/easyepg
#
#      Collaborators:
#      - DeBaschdi ( https://github.com/DeBaschdi )
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with easyepg. If not, see <http://www.gnu.org/licenses/>.

# ##############################
# HORIZON CHANNEL LIST CREATOR #
# ##############################

# COMPARE STRINGS, CREATE CRID LIST

use strict;
use warnings;
 
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use utf8;
 
use JSON;

# READ JSON INPUT FILE: COMPARISM LIST
my $compare;
{
    local $/; #Enable 'slurp' mode
    open my $fh, "<", "/tmp/compare.json" or die;
    $compare = <$fh>;
    close $fh;
}

# READ JSON INPUT FILE: PROGRAMME LIST
my $programme;
{
    local $/; #Enable 'slurp' mode
    open my $fh, "<", "day/dayNUMBER" or die;
    $programme = <$fh>;
    close $fh;
}

# CONVERT JSON TO PERL STRUCTURES
my $comparedata      = decode_json($compare);
my $programmedata    = decode_json($programme);

#
# DEFINE JSON VALUES
#

# DEFINE COMPARE DATA
my $new_name2id = $comparedata->{'newname2id'};
my $new_id2name = $comparedata->{'newid2name'};
my $old_name2id = $comparedata->{'oldname2id'};
my $old_id2name = $comparedata->{'oldid2name'};
my @configname  = @{ $comparedata->{'config'} };

# DEFINE PROGRAMME STRINGS
my @entries = @{ $programmedata->{'entries'} };

my $crid = "i";
my $crid_location;

#
# COMPARE VALUES + CREATE CRID LIST
#

foreach my $entries ( @entries ) {
	my @lid = @{ $entries->{'l'} };
	my $oid = $entries->{'o'};
	
	foreach my $lid ( @lid ) {
		my $crid = $lid->{'i'};

		foreach my $configname ( @configname ) {
		
			# DEFINE IDs
			my $old_id = $old_name2id->{$configname};
			my $new_id = $new_name2id->{$configname};
			
			# FIND MATCH - NEW + OLD CHANNEL ID VIA CONFIG NAME
			if( $new_id eq $old_id ) {
				
				if( $oid eq $new_id ) {
					print $crid . "\n";
				}
			
			# IF MATCH NOT FOUND: FIND CHANNEL NAME IN NEW CHANNEL LIST
			} elsif( defined $new_id ) {
				print STDERR "[ INFO ] CHANNEL \"$configname\" received new Channel ID!\n";
				
				if( $oid eq $new_id ) {
					print $crid . "_NEW_ID\n";
				}
				
			} else {
				print STDERR "[ WARNING ] CHANNEL $configname not found in channel list!\n";
			}
		}
	}
}
