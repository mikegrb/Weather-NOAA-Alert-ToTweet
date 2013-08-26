#!/usr/bin/env perl

use 5.010;
use strict;
use warnings;

use Mojo::UserAgent;
use Data::Dumper;

my $ua = Mojo::UserAgent->new();


while (my $line = <>) {
    chomp ($line);
    my $name = twat_to_name($line);
    say "$line\t$name";
    sleep 5;
}

sub twat_to_name {
    my $twatter = shift;
    $twatter =~ s/\@//;
    my $title   = $ua->new->get("https://twitter.com/$twatter")
        ->res->dom->html->head->title->text;
    return ( split / \(/, $title )[0];
}
