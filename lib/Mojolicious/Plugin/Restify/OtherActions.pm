use strict;
use warnings;
package Mojolicious::Plugin::Restify::OtherActions;

use Mojo::Base 'Mojolicious::Plugin::Restify';

sub register() {
    my $s = shift;
    my ($app, $conf) = @_;
    $s->SUPER::register(@_);
    my $original_code = $app->routes->shortcuts->{collection};
    $app->routes->add_shortcut(
        # replace original shortcut
        collection => sub {
            my $coll    = $original_code->(@_);
            my $r       = shift;
            my $path    = shift;
            my $options = ref $_[0] eq 'HASH' ? shift : {@_};
            my $or      = $r->find("$options->{route_name}");
            $or->get("list/:query/*opt")->to(action => 'list',
                opt => undef)->name($options->{route_name} . "_otheractions");
            return $coll;

        }
    );
}

1;

__END__

# ABSTRACT: Mojolicious plug-in which extends Restify with more actions

=pod

=encoding UTF-8

=begin :badge

=begin html

<p><img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/EmilianoBruni/Mojolicious-Plugin-Restify-OtherActions?style=plastic"> <a href="https://travis-ci.com/EmilianoBruni/mojolicious-plugin-mongodbv2"><img alt="Travis tests" src="https://img.shields.io/travis/com/EmilianoBruni/Mojolicious-Plugin-Restify-OtherActions?label=Travis%20tests&style=plastic"></a></p>

=end html

=end :badge

=head1 SYNOPSIS

    plugin 'Restify::OtherActions';

=head1 DESCRIPTION

=head1 BUGS/CONTRIBUTING

Please report any bugs through the web interface at L<https://github.com/EmilianoBruni/Mojolicious-Plugin-Restify-OtherActions/issues>
If you want to contribute changes or otherwise involve yourself in development, feel free to fork the Git repository from
L<https://github.com/EmilianoBruni/Mojolicious-Plugin-Restify-OtherActions/>.

=head1 SUPPORT

You can find this documentation with the perldoc command too.

    perldoc Mojolicious::Plugin::Restify::OtherActions

=cut
