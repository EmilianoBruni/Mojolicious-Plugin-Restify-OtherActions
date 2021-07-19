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

Extends L<Mojolicious::Plugin::Restify> allowing to call other methods over REST collection

=head1 USAGE

When you create your controller (see L<Mojolicious::Plugin::Restify> documentation),
you can use, as an example, this list method

  sub list {
    my $c		= shift;
    my $query =  $c->stash('query');
    return $c->$query if ($query);
    ...your original list code ...
  }

to redirect your call to an alternative $query method.

As an example, if your endpoint is C</accounts> then C</accounts/list/my_method/other/parameters>
is redirect to C<< $c->my_method >> and remaining url is available in C<< $c->stash->('opt') >>.

In addition to standard routes added by L<Mojolicious::Plugin::Restify>, a new route is added

    # Pattern             Methods   Name                        Class::Method Name
    # -------             -------   ----                        ------------------
    # ....
    # +/list/:query/*opt  GET       accounts_otheractions       Accounts::$query



=head1 BUGS/CONTRIBUTING

Please report any bugs through the web interface at L<https://github.com/EmilianoBruni/Mojolicious-Plugin-Restify-OtherActions/issues>
If you want to contribute changes or otherwise involve yourself in development, feel free to fork the Git repository from
L<https://github.com/EmilianoBruni/Mojolicious-Plugin-Restify-OtherActions/>.

=head1 SUPPORT

You can find this documentation with the perldoc command too.

    perldoc Mojolicious::Plugin::Restify::OtherActions

=cut
