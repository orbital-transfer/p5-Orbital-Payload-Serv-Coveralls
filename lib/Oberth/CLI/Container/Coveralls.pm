use Modern::Perl;
package Oberth::CLI::Container::Coveralls;
# ABSTRACT: Container for Coveralls

use Oberth::Manoeuvre::Common::Setup;

method commands() {
	return +{
		'service/coveralls' =>'Oberth::CLI::Command::Coveralls',
	}
}

1;
