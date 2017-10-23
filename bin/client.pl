#!/usr/bin/perl

use strict;
use warnings;

use REST::Client;
use Data::Dumper;
use JSON; # sudo capn install JSON
use Switch;

#The basic use case
my $client = REST::Client->new();
my $debug = 0;

#A host can be set for convienience
#$client->GET('http://localhost:6666/api/world/objects');
my $RESTFUL_HOST="localhost";
my $RESTFUL_PORT="6666";

my %action = (
    "type"      => "forward",
    "amount"    => 10000
);

#GetMap();

my $req = '{
"type": "forward", 
"amount": 200
}';

#SendAction ( $client, "player", $req );

#print GetDirection( $client );

#SetDirection ( $client, "player", "turn-right", "North" );

#SetAngle ( $client, 300 );

# Lets find what 360 takes
GetCompass ( $client );

sub GetCompass {

    my ( $client ) = @_;

    my $playerAngle = GetPlayerAngle( $client );
    my $startAngle = $playerAngle;
    print "Angle: $playerAngle\n";

    my $angle = GetPlayerAngle( $client );
    my $checkAngle = int ( $angle / 5 );
    my $turned = 0; 

    while ( $checkAngle != 0 ) {
        
        my $before = GetPlayerAngle( $client );
        TurnPlayer ( $client, 2 ); # Two is least amount of visible movement
        my $after = GetPlayerAngle ( $client );
        
        $angle = GetPlayerAngle( $client );
        $checkAngle = int ( $angle / 5 );
        my $moved = 
        print "Angle: $angle\n";
    }



}

sub SetAngle {

    my ( $client, $angle ) = @_;

    # Nick : Roughly 105 directions available

    my $playerAngle = GetPlayerAngle( $client );
    print "Player Angle: $playerAngle\n";

    my $diff = $angle - $playerAngle;
    $diff-= 180 if $diff > 180;

    print "Diff: $diff\n";

    print "We are facing $playerAngle and we want to be facing $angle, a difference of $diff\n";

    TurnPlayer ( $client, $diff );

}

sub TurnPlayer {

    my ( $client, $amount ) = @_;

    my ( $req, $direction );

    if ( $amount < 0 )  {
        $req = "{ \"type\": \"turn-left\", \"amount\": $amount }"; 
    }
    else {
        $req = "{ \"type\": \"turn-right\", \"amount\": $amount }"; 
    }

    my $url = "http://localhost:6666/api/player/actions";
    print "$url\n" if $debug;
    print "$req\n" if $debug;

    $client->POST($url, $req );





}

sub GetPlayerAngle {

    my ( $client ) = @_;

    $client->GET("http://localhost:6666/api/player");
    my $content = decode_json $client->responseContent();

    #print Dumper $content;

    return $content->{angle};

}

sub GetMap {

    #my $hash = $client->GET('http://localhost:6666/api/world/objects');
    my $hash = $client->GET('http://localhost:6666/api/player');


    print $client->responseContent();
    #print $hash-

}

sub SendAction {

    my ( $client, $actionType, $req ) = @_;

    my $url = "http://localhost:6666/api/$actionType/actions";

    $client->POST($url, $req );

}
