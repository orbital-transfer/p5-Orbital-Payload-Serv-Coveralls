use Orbital::Transfer::Common::Setup;
package Orbital::CLI::Container::Coveralls;
# ABSTRACT: Container for Coveralls

use Orbital::Transfer::Common::Setup;

method commands() {
	return +{
		'service/coveralls' =>'Orbital::CLI::Command::Coveralls',
	}
}

1;
