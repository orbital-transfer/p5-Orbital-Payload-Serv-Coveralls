use strict;
use warnings;
use Test::More;


use Oberth::Block::Service::Coveralls;
use Oberth::Block::Service::GitHub::User;
use Oberth::Block::Service::GitHub;

my $cv = Oberth::Block::Service::Coveralls->new;

my %cred = Oberth::Block::Service::GitHub->_get_github_user_pass;

#$cred{password} = ".";
$cv->auth_to_github( \%cred );

#use DDP; p $auth_github_redirect_to_coveralls;

my $repos = $cv->repos;
my $first_repo = $repos->[0];

use DDP; p $first_repo;

use DDP; p $cv->build_history_for_repo( $first_repo );
