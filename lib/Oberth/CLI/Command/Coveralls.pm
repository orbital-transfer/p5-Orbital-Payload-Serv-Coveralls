use Oberth::Manoeuvre::Common::Setup;
package Oberth::CLI::Command::Coveralls;
# ABSTRACT: A command for Coveralls

use Moo;
use CLI::Osprey;

use JSON::MaybeXS;
use Oberth::Block::Service::Coveralls;
use Oberth::Block::Service::GitHub;
use List::AllUtils qw(first);

has _coveralls => ( is => 'lazy' );

has token => ( is => 'lazy' );

method _build_token() {
	my $token = `git config --global oberth.coveralls-token`;
	chomp $token;

	$token;
}


method _build__coveralls() {
	my $cv = Oberth::Block::Service::Coveralls->new;

	my %cred = Oberth::Block::Service::GitHub->_get_github_user_pass;

	$cv->auth_to_github( \%cred );

	$cv;
}

subcommand sync => method() {
	$self->_coveralls->get( $self->_coveralls->coveralls_domain . '/refresh' );
};

subcommand 'github-repos' => method() {
	my $gh = $self->github_repo_origin;

	my $uri = URI->new('https://coveralls.io/repos/new.json');
	$uri->query_form(
		name => $gh->namespace . '/',
		page => 1,
		service => 'github',
	);
	my $response = $self->_coveralls->ua->get( $uri );
};

# See <https://github.com/lemurheavy/coveralls-public/issues/769>,
# <https://coveralls.io/api/docs>.
subcommand enable => method() {
	my $gh = $self->github_repo_origin;
	#my $repos = $self->_coveralls->repos;
	#my $cv_repo = first {
		#$gh->namespace eq $_->github->namespace
		#&& $gh->name eq $_->github->name
	#} @$repos;

	my $response = $self->_coveralls->ua->post(
		'https://coveralls.io/api/repos',
		Authorization => 'token '. $self->token,
		'Content-Type' => 'application/json',
		Accept => 'application/json',
		Content => encode_json({
			repo => {
				service => 'github',
				name => $gh->namespace . "/" . $gh->name,
				comment_on_pull_requests => JSON->true,
				send_build_status => JSON->true,
			},
		}),
	);

	my $response_json = decode_json($response->decoded_content);
	use DDP; p $response_json;
};

with qw(Oberth::CLI::Command::Role::GitHubRepos);

1;
