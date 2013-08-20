package Weather::NOAA::Alert::ToTweet;

use warnings;
use strict;
use 5.008_005;

use Exporter 'import';

our $VERSION   = '0.01';
our @EXPORT_OK = ('generate_tweet_from_alert');

our %twats = (
    'NWS Storm Prediction Center (Storm Prediction Center - Norman, Oklahoma)'
        => '@NWSSPC',
    'NWS Philadelphia - Mount Holly (New Jersey, Delaware, Southeastern Pennsylvania)'
        => '@NWS_MountHolly',
);

sub generate_tweet_from_alert {
    my ( $event, $cap_data, $county_name ) = @_;

    my $short_sender;
    my $tweet = $cap_data->{headline};
    my $county_string = $county_name ? "for $county_name " : '';

    if ( $tweet =~ m/(?:Weather Statement|Air Quality Alert)/ ) {
        $tweet
            =~ s/issued \S+ \d+ at (\d+:\d+(?:A|P)M) E(?:S|DT) ? by (.*)$/issued at $1/;
        $short_sender = $2;
    }
    else {
        $tweet
            =~ s/issued .*?until (.*? at \d+:\d+(?:A|P)M) E(?:S|DT) by (.*)$/${county_string}until $1, issued/;
        $short_sender = $2;
    }

    my $issued_by
        = exists( $twats{ $cap_data->{senderName} } )
        ? $twats{ $cap_data->{senderName} }
        : $short_sender;
    $tweet .= " by $issued_by $event";
    return $tweet;
}

1;
__END__

=encoding utf-8

=head1 NAME

Weather::NOAA::Alert::ToTweet - generate tweet from Weather::NOAA::Alert event data structure

=head1 SYNOPSIS
  
  use Weather::NOAA::Alert;
  use Weather::NOAA::Alert::ToTweet 'generate_tweet_from_alert';


  my $twitter = Net::Twitter->new(%args)

  my $alerts = Weather::NOAA::Alert->new(['ZONECODE']);
  $alerts->poll_events();  

  my $events = $alert->get_events()->{$noaa_county_zone};
  for my $event ( keys %{$events} ) {
    my $tweet = generate_tweet_from_alert( $event, $events->{event}, $county_name )
    $twitter->update($tweet);    
  }

=head1 DESCRIPTION

Weather::NOAA::Alert::ToTweet is blah blah blah

=head1 AUTHOR

Mike Greb E<lt>michael@thegrebs.comE<gt>

=head1 COPYRIGHT

Copyright 2013- Mike Greb

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

tweet-alerts.pl in the examples directory

L<Weather::NOAA::Alert>

L<Net::Twitter>

=cut
