#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use YAML::Tiny;
use Net::Twitter;
use Data::Dumper;
use Weather::NOAA::Alert;
use Weather::NOAA::Alert::ToTweet;

my $consumer_key        = '';
my $consumer_secret     = '';
my $access_token        = '';
my $access_token_secret = '';

# path for YAML file to keep track of alerts we've already seen/tweeted
my $seen_alerts_path = '/tmp/alert-seen.yml';

# Replace with your county zone code from http://alerts.weather.gov/
my $noaa_county_zone = 'NJZ022';

# County is included with the name to account for states such as Luisiana where
# they are called parishes instead
my $county_string = 'Atlantic County';

# Which events cause a tweet?

# List from: 22 june 2012 http://alerts.weather.gov/cap/product_list.txt
my %event_gets_tweeted = (
    '911 Telephone Outage'                       => 1,
    'Administrative Message'                     => 1,
    'Air Quality Alert'                          => 1,
    'Air Stagnation Advisory'                    => 1,
    'Ashfall Advisory'                           => 1,
    'Ashfall Warning'                            => 1,
    'Avalanche Warning'                          => 1,
    'Avalanche Watch'                            => 1,
    'Beach Hazards Statement'                    => 0,
    'Blizzard Warning'                           => 1,
    'Blizzard Watch'                             => 1,
    'Blowing Dust Advisory'                      => 1,
    'Blowing Snow Advisory'                      => 1,
    'Brisk Wind Advisory'                        => 0,
    'Child Abduction Emergency'                  => 1,
    'Civil Danger Warning'                       => 1,
    'Civil Emergency Message'                    => 1,
    'Coastal Flood Advisory'                     => 0,
    'Coastal Flood Statement'                    => 0,
    'Coastal Flood Warning'                      => 0,
    'Coastal Flood Watch'                        => 0,
    'Dense Fog Advisory'                         => 1,
    'Dense Smoke Advisory'                       => 1,
    'Dust Storm Warning'                         => 1,
    'Earthquake Warning'                         => 1,
    'Evacuation Immediate'                       => 1,
    'Excessive Heat Warning'                     => 1,
    'Excessive Heat Watch'                       => 1,
    'Extreme Cold Warning'                       => 1,
    'Extreme Cold Watch'                         => 1,
    'Extreme Fire Danger'                        => 1,
    'Extreme Wind Warning'                       => 1,
    'Fire Warning'                               => 1,
    'Fire Weather Watch'                         => 1,
    'Flash Flood Statement'                      => 1,
    'Flash Flood Warning'                        => 1,
    'Flash Flood Watch'                          => 1,
    'Flood Advisory'                             => 0,
    'Flood Statement'                            => 0,
    'Flood Warning'                              => 1,
    'Flood Watch'                                => 1,
    'Freeze Warning'                             => 0,
    'Freeze Watch'                               => 0,
    'Freezing Drizzle Advisory'                  => 1,
    'Freezing Fog Advisory'                      => 1,
    'Freezing Rain Advisory'                     => 1,
    'Freezing Spray Advisory'                    => 0,
    'Frost Advisory'                             => 0,
    'Gale Warning'                               => 1,
    'Gale Watch'                                 => 1,
    'Hard Freeze Warning'                        => 0,
    'Hard Freeze Watch'                          => 0,
    'Hazardous Materials Warning'                => 1,
    'Hazardous Seas Warning'                     => 0,
    'Hazardous Seas Watch'                       => 0,
    'Hazardous Weather Outlook'                  => 0,
    'Heat Advisory'                              => 1,
    'Heavy Freezing Spray Warning'               => 0,
    'Heavy Freezing Spray Watch'                 => 0,
    'Heavy Snow Warning'                         => 1,
    'High Surf Advisory'                         => 0,
    'High Surf Warning'                          => 0,
    'High Wind Warning'                          => 1,
    'High Wind Watch'                            => 1,
    'Hurricane Force Wind Warning'               => 1,
    'Hurricane Force Wind Watch'                 => 1,
    'Hurricane Statement'                        => 1,
    'Hurricane Warning'                          => 1,
    'Hurricane Watch'                            => 1,
    'Hurricane Wind Warning'                     => 1,
    'Hurricane Wind Watch'                       => 1,
    'Hydrologic Advisory'                        => 1,
    'Hydrologic Outlook'                         => 0,
    'Ice Storm Warning'                          => 1,
    'Lake Effect Snow Advisory'                  => 0,
    'Lake Effect Snow and Blowing Snow Advisory' => 0,
    'Lake Effect Snow Warning'                   => 0,
    'Lake Effect Snow Watch'                     => 0,
    'Lakeshore Flood Advisory'                   => 0,
    'Lakeshore Flood Statement'                  => 0,
    'Lakeshore Flood Warning'                    => 0,
    'Lakeshore Flood Watch'                      => 0,
    'Lake Wind Advisory'                         => 0,
    'Law Enforcement Warning'                    => 1,
    'Local Area Emergency'                       => 1,
    'Low Water Advisory'                         => 0,
    'Marine Weather Statement'                   => 0,
    'Nuclear Power Plant Warning'                => 1,
    'Radiological Hazard Warning'                => 1,
    'Red Flag Warning'                           => 1,
    'Rip Current Statement'                      => 0,
    'Severe Thunderstorm Warning'                => 1,
    'Severe Thunderstorm Watch'                  => 1,
    'Severe Weather Statement'                   => 1,
    'Shelter In Place Warning'                   => 1,
    'Sleet Advisory'                             => 1,
    'Sleet Warning'                              => 1,
    'Small Craft Advisory'                       => 0,
    'Snow Advisory'                              => 1,
    'Snow and Blowing Snow Advisory'             => 1,
    'Special Marine Warning'                     => 0,
    'Special Weather Statement'                  => 0,
    'Storm Warning'                              => 1,
    'Storm Watch'                                => 1,
    'Test'                                       => 0,
    'Tornado Warning'                            => 1,
    'Tornado Watch'                              => 1,
    'Tropical Storm Warning'                     => 1,
    'Tropical Storm Watch'                       => 1,
    'Tropical Storm Wind Warning'                => 1,
    'Tropical Storm Wind Watch'                  => 1,
    'Tsunami Advisory'                           => 1,
    'Tsunami Warning'                            => 1,
    'Tsunami Watch'                              => 1,
    'Typhoon Statement'                          => 1,
    'Typhoon Warning'                            => 1,
    'Typhoon Watch'                              => 1,
    'Volcano Warning'                            => 1,
    'Wind Advisory'                              => 1,
    'Wind Chill Advisory'                        => 1,
    'Wind Chill Warning'                         => 1,
    'Wind Chill Watch'                           => 1,
    'Winter Storm Warning'                       => 1,
    'Winter Storm Watch'                         => 1,
    'Winter Weather Advisory'                    => 1,

);

my $yaml = YAML::Tiny->read( $seen_alerts_path ) || YAML::Tiny->new;

my $new_alerts = 0;

try {
    my $alert = Weather::NOAA::Alert->new( [$noaa_county_zone] );
    $alert->errorLog(1);
    $alert->poll_events();

    my $events = $alert->get_events()->{$noaa_county_zone};
    for my $event ( keys %{$events} ) {
        next if ( $yaml->[0]{seen_cap}{$event} );
        $yaml->[0]->{seen_cap}{$event} = localtime;
        $new_alerts++;

        say Dumper( $events->{$event} );

        my $tweet
            = Weather::NOAA::Alert::ToTweet::generate_tweet_from_alert( $event,
            $events->{$event}, $county_string );

        print "Generated Tweet:\n\t$tweet\n";

        if ( $event_gets_tweeted{ $events->{$event}{event} } ) {
            my $nt = Net::Twitter->new(
                traits              => [qw/OAuth API::RESTv1_1/],
                consumer_key        => $consumer_key,
                consumer_secret     => $consumer_secret,
                access_token        => $access_token,
                access_token_secret => $access_token_secret,
            );
            $nt->update($tweet);
            print "Tweeted.\n";
        }
    }
}
catch {
    die $_
        unless $_ =~ m/^Can't call method "children" on an undefined value/;
};

$yaml->write($seen_alerts_path) if $new_alerts;
