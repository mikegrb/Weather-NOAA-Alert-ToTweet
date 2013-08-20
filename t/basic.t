use strict;
use Test::More;
use Weather::NOAA::Alert::ToTweet;

my %test_data = (
    'Severe Thunderstorm Watch from NWS SPC' => {
        tweet => 'Severe Thunderstorm Watch until June 28 at 9:00PM, issued by @NWSSPC',
        country => undef,
        data => {
            'event'       => 'Severe Thunderstorm Watch',
            'effective'   => '2013-06-28T14:10:00-04:00',
            'severity'    => 'Severe',
            'category'    => 'Met',
            'instruction' => '',
            'expires'     => '2013-06-28T21:00:00-04:00',
            'delete'      => 0,
            'urgency'     => 'Expected',
            'certainty'   => 'Likely',
            'senderName' =>
                'NWS Storm Prediction Center (Storm Prediction Center - Norman, Oklahoma)',
            'headline' =>
                'Severe Thunderstorm Watch issued June 28 at 2:10PM EDT until June 28 at 9:00PM EDT by NWS Storm Prediction Center',
            'description' => 'blah blah blah',
        }
    },
    'Rip Current Statement' => {
        tweet => 'Rip Current Statement until June 30 at 11:00PM, issued by @NWS_MountHolly',
        county => undef,
        data => {
            'certainty'   => 'Likely',
            'urgency'     => 'Expected',
            'instruction' => 'blah blah',
            'description' => 'blah blah',
            'event'       => 'Rip Current Statement',
            'delete'      => 0,
            'category'    => 'Met',
            'severity'    => 'Moderate',
            'expires'     => '2013-06-30T23:00:00-04:00',
            'effective'   => '2013-06-30T05:29:00-04:00',
            'headline' =>
                'Rip Current Statement issued June 30 at 5:29AM EDT until June 30 at 11:00PM EDT by NWS Philadelphia - Mount Holly',
            'senderName' =>
                'NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)',
        }
    },
    'Flood Advisory' => {
        tweet => 'Flood Advisory for until July 01 at 4:30PM, issued by @NWS_MountHolly',
        county => undef,
        data => {
            'certainty'   => 'Likely',
            'urgency'     => 'Expected',
            'instruction' => 'blah',
            'description' => 'blah blah',
            'event'       => 'Flood Advisory',
            'delete'      => 0,
            'category'    => 'Met',
            'severity'    => 'Minor',
            'expires'     => '2013-07-01T16:30:00-04:00',
            'effective'   => '2013-07-01T12:36:00-04:00',
            'senderName' =>
                'NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)',
            'headline' =>
                'Flood Advisory issued July 01 at 12:36PM EDT until July 01 at 4:30PM EDT by NWS Philadelphia - Mount Holly',
        }
    },
    'Spc Weather Statement' => {
        tweet => 'Special Weather Statement issued at 5:20PM by @NWS_MountHolly',
        county => undef,
        data  => {
            'certainty'   => 'Observed',
            'urgency'     => 'Expected',
            'instruction' => '',
            'description' => 'blah blah',
            'event'       => 'Special Weather Statement',
            'delete'      => 0,
            'category'    => 'Met',
            'severity'    => 'Minor',
            'effective'   => '2013-07-08T17:20:00-04:00',
            'expires'     => '2013-07-08T18:15:00-04:00',
            'senderName' =>
                'NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)',
            'headline' =>
                'Special Weather Statement issued July 08 at 5:20PM EDT  by NWS Philadelphia - Mount Holly',
        }
    },
    'Air Quality Alert' => {
        tweet => 'Air Quality Alert issued at 9:42AM by @NWS_MountHolly',
        county => undef,
        data => {
            'certainty' => 'Unknown',
            'senderName' => 'NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)',
            'urgency' => 'Unknown',
            'instruction' => '',
            'description' => 'blah blah',
            'event' => 'Air Quality Alert',
            'delete' => 0,
            'category' => 'Met',
            'severity' => 'Unknown',
            'effective' => '2013-07-17T09:42:00-04:00',
            'headline' => 'Air Quality Alert issued July 17 at 9:42AM EDT  by NWS Philadelphia - Mount Holly',
            'expires' => '2013-07-18T00:00:00-04:00'
        }
    },
    'Severe Thunderstorm Watch from NWS SPC' => {
        tweet => 'Severe Thunderstorm Watch for Atlantic County until June 28 at 9:00PM, issued by @NWSSPC',
        county => 'Atlantic County',
        data => {
            'event'       => 'Severe Thunderstorm Watch',
            'effective'   => '2013-06-28T14:10:00-04:00',
            'severity'    => 'Severe',
            'category'    => 'Met',
            'instruction' => '',
            'expires'     => '2013-06-28T21:00:00-04:00',
            'delete'      => 0,
            'urgency'     => 'Expected',
            'certainty'   => 'Likely',
            'senderName' =>
                'NWS Storm Prediction Center (Storm Prediction Center - Norman, Oklahoma)',
            'headline' =>
                'Severe Thunderstorm Watch issued June 28 at 2:10PM EDT until June 28 at 9:00PM EDT by NWS Storm Prediction Center',
            'description' => 'blah blah blah',
        }
    },
    'Rip Current Statement' => {
        tweet => 'Rip Current Statement for Atlantic County until June 30 at 11:00PM, issued by @NWS_MountHolly',
        county => 'Atlantic County',
        data => {
            'certainty'   => 'Likely',
            'urgency'     => 'Expected',
            'instruction' => 'blah blah',
            'description' => 'blah blah',
            'event'       => 'Rip Current Statement',
            'delete'      => 0,
            'category'    => 'Met',
            'severity'    => 'Moderate',
            'expires'     => '2013-06-30T23:00:00-04:00',
            'effective'   => '2013-06-30T05:29:00-04:00',
            'headline' =>
                'Rip Current Statement issued June 30 at 5:29AM EDT until June 30 at 11:00PM EDT by NWS Philadelphia - Mount Holly',
            'senderName' =>
                'NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)',
        }
    },
    'Flood Advisory' => {
        tweet => 'Flood Advisory for Atlantic County until July 01 at 4:30PM, issued by @NWS_MountHolly',
        county => 'Atlantic County',
        data => {
            'certainty'   => 'Likely',
            'urgency'     => 'Expected',
            'instruction' => 'blah',
            'description' => 'blah blah',
            'event'       => 'Flood Advisory',
            'delete'      => 0,
            'category'    => 'Met',
            'severity'    => 'Minor',
            'expires'     => '2013-07-01T16:30:00-04:00',
            'effective'   => '2013-07-01T12:36:00-04:00',
            'senderName' =>
                'NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)',
            'headline' =>
                'Flood Advisory issued July 01 at 12:36PM EDT until July 01 at 4:30PM EDT by NWS Philadelphia - Mount Holly',
        }
    },

);

for my $test ( keys %test_data ) {
    is( Weather::NOAA::Alert::ToTweet::generate_tweet_from_alert(
            'URL', $test_data{$test}{data}, $test_data{$test}{county}
        ),
        $test_data{$test}{tweet} . ' URL',
        $test
    );
}

done_testing;
