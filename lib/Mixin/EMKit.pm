package Mixin::EMKit;

use 5.006001;

use strict;
use warnings;

use File::ShareDir ();
use File::Spec ();
use Email::MIME::Kit;

use Sub::Exporter::Util;
use Sub::Exporter 0.978 -setup => {
  installer => Sub::Exporter::Util::mixin_installer,
  exports => [
    qw(kit kit_dir),
    kit_root_dir => \&_build_kit_root_dir
  ],
  groups     => { default => [qw(-all)] },
  collectors => [ -setup => \&_setup ],
};

=head1 NAME

Mixin::EMKit - mixin for Email::MIME::Kit

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    package Foo;
    use Mixin::EMKit;
    ...

    package main;
    my $obj = Foo->new;
    my $kit = $obj->kit($dir, \%arg);

=head1 SETUP

  use Mixin::EMKit -setup => { foo => 1 };

Several options for configuring Mixin::EMKit's behavior can
be passed in via the C<-setup> argument to the C<use> statement.

=over 4

=item * kit_root_dir

See L<C<kit_root_dir()>|/kit_root_dir>.  If this value is
passed in, it will be used instead of calling C<module_dir>.
NOTE: C</kit> will still be appended to this value!

=back

=head2 kit

=head1 FUNCTIONS

=head2 kit

See L<SYNOPSIS|SYNOPSIS> for usage.

Uses L<C<kit_dir()>|/kit_dir>, then passes arguments off to 
L<< Email::MIME::Kit->new() |Email::MIME::Kit/new >>.

If your class has a method called C< email_mime_kit_class >,
it should return a class name, which will be used instead of
Email::MIME::Kit.

This does not attempt to C<require> the named class, so if
you override the default, you will have to load your class
manually.

=cut

sub kit {
  my ($self, $name, $opt) = @_;
  $opt ||= {};
  $opt->{stash} ||= {};
  $opt->{stash}->{self} = $self;
  my $kit_class = $self->can("email_mime_kit_class") ?
    $self->email_mime_kit_class : 'Email::MIME::Kit';
  return $kit_class->new( $self->kit_dir($name), $opt );
}

=head2 kit_dir

  my $dir = $obj->kit_dir($fragment);

Use L<C<kit_root_dir()>|/kit_root_dir>, then append C<.mkit> if necessary.

=cut

sub kit_dir {
  my ($self, $name) = @_;
  my $dir = File::Spec->catdir($self->kit_root_dir, $name);
  $dir .= '.mkit' if ! -e $dir && -e "$dir.mkit";
  return $dir;
}

=head2 kit_root_dir

Returns L<File::ShareDir|File::ShareDir>'s
L<C<module_dir()>|File:ShareDir/module_dir> with C</kit>
appended.

This is an easy place for subclasses to override.

See also the C<kit_root_dir> parameter in L</SETUP>.

=cut

sub _setup {
  my ($coll, $arg) = @_;
  # reimplement -default because using a collection 'breaks' it
  @{$arg->{import_args}} = ['-all'] unless @{$arg->{import_args}};
}

sub _build_kit_root_dir {
  my ($class, $name, $arg, $coll) = @_;
  return sub {
    my $self = shift;
    return File::Spec->catdir(
      $coll->{-setup}->{kit_root_dir} || 
        File::ShareDir::module_dir(ref($self) || $self),
      'kit',
    );
  };
}

=head1 AUTHOR

Hans Dieter Pearcey, C<< <hdp at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-mixin-emkit at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Mixin-EMKit>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Mixin::EMKit

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Mixin-EMKit>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Mixin-EMKit>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Mixin-EMKit>

=item * Search CPAN

L<http://search.cpan.org/dist/Mixin-EMKit>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Hans Dieter Pearcey, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Mixin::EMKit
