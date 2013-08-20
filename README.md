# NAME

Weather::NOAA::Alert::ToTweet - generate tweet from Weather::NOAA::Alert event data structure

# SYNOPSIS
  

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

# DESCRIPTION

Weather::NOAA::Alert::ToTweet is blah blah blah

# AUTHOR

Mike Greb <michael@thegrebs.com>

# COPYRIGHT

Copyright 2013- Mike Greb

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

tweet-alerts.pl in the examples directory

[Weather::NOAA::Alert](http://search.cpan.org/perldoc?Weather::NOAA::Alert)

[Net::Twitter](http://search.cpan.org/perldoc?Net::Twitter)
