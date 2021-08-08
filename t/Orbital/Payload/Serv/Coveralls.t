use strict;
use warnings;
use Test::More;


use Orbital::Payload::Serv::Coveralls;
use Orbital::Payload::Serv::GitHub::User;
use Orbital::Payload::Serv::GitHub;

my $cv = Orbital::Payload::Serv::Coveralls->new;

my %cred = Orbital::Payload::Serv::GitHub->_get_github_user_pass;

#$cred{password} = ".";
$cv->auth_to_github( \%cred );

#use DDP; p $auth_github_redirect_to_coveralls;

my $repos = $cv->repos;
my $first_repo = $repos->[0];

use DDP; p $first_repo;

use DDP; p $cv->build_history_for_repo( $first_repo );
