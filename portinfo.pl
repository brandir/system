#!/usr/local/bin/perl
# Time-stamp: <2020-05-04 10:18:07 (mellon@yavanna) portinfo.pl>

# https://github.com/brandir/system
# cf. http://perldoc.perl.org/Getopt/Long.html

use warnings;
use Getopt::Long;
use Pod::Usage;
use Date::Parse;

my $program = 'portinfo.pl';
my $version = '1.0';
my $year = 2018;
my $month = 'July';
my $man = 0;
my $help = 0;

my $all = 0;      # disabled per default
my $aux = 0;      # auxiliary for dev/test
my $cache = 1;    # enable default result caching
my $port = '';
my $verbose = 0;  # non-verbose per default

my @origin = qw(archivers devel editors emulators ftp graphics java lang mail math multimedia net net-im net-mgmt);

sub show_version {
    print "$program v$version ($month $year)\n";
    exit 0;
}

sub date2epoch {
    my $epoch = 0;
    my ($date) = @_;
    $epoch = str2time($date);
    return $epoch;
}

sub get_ports {
    my $entry = 1;
    my $nextline = 0;
    my %ports;
    # port, version, date, origin/port, bsdversion, epoch
    my $port;
    open PORTS, "portmaster -l |" or die "Couldn't execute 'portmaster -l': $!";
    while (defined(my $port = <PORTS>)) {
        if ($entry == 1) { # to be checked
            $entry = 0;
            next;
        }
        my $bsdversion = 'N/A';
        chomp($port);
        if ($port !~ /root|trunk|branch|leaf|installed|^$/i) {
            $port =~ s/^===>>> //g;
#           print "############ $port\n";
            open PORT, "pkg info $port|" or die "Couldn execute 'pkg info $port': $!";
            while (defined(my $p = <PORT>)) {
                chomp($p);
                $_ = $p;
                my @portinfo = split /\n/, $_;
                foreach my $portinfo (@portinfo) {
                    if ($portinfo =~ /^Name/) {
                        $portinfo =~ s/^Name\s+:\s//;
                        # print "--- $portinfo\n";
                        $ports{'port'} = $portinfo;
                    }
                    if ($portinfo =~ /^Version/) {
                        $portinfo =~ s/Version\s+:\s//;
                        # print "--- $portinfo\n";
                        $ports{'version'} = $portinfo;
                    }
                    if ($portinfo =~ /^Installed on/) {
                        $portinfo =~ s/Installed on\s+:\s//;
                        # print "--- $portinfo\n";
                        $ports{'date'} = $portinfo;
                        $ports{'epoch'} = date2epoch($portinfo);
                    }
                    if ($portinfo =~ /^Origin/) {
                        $portinfo =~ s/^Origin\s+:\s//;
                        # print "--- $portinfo\n";
                        $ports{'origin'} = $portinfo;
                    }
                }
#               print "-- before ann. -- $_\n";
                $nextline = 2 if (/^Annotations/);
                # $_ contains now FreeBSD_version
                # print "%% $port - $_\n"
                $bsdversion = $_ if (($nextline-->0) && $_ !~ /^Annotations/ && $_ =~ /FreeBSD_version/);
                $bsdversion =~ s/^\s+|\s+$//g;
                $ports{'bsdversion'} = $bsdversion;
            }
        }
        printf("%-35s %-20s %-30s %-40s %-25s %-10s\n", $ports{'port'}, $ports{'version'}, $ports{'date'}, $ports{'origin'}, $ports{'bsdversion'}, $ports{'epoch'});
    }
}

Getopt::Long::Configure("bundling", "no_ignore_case", "permute", "no_getopt_compat");

GetOptions ('all|a'         => \$all,
            'aux|x=i'       => \$aux,
            'cache|c'       => \$cache,
            'help|h|?'      => \&show_help,
            'origin|o=s'    => \$origin,
            "port|p=s"      => \$port,
            'verbose|v!'   => \$verbose,
            'version|V'     => \&show_version)
    or die("Error in command line arguments!\n");

if ($aux) {
    get_ports();
    exit 0;
}

if ($all) {
    print "Processing all ports ...\n";
    foreach (@origin) {
...skipping...
    }
}

Getopt::Long::Configure("bundling", "no_ignore_case", "permute", "no_getopt_compat");

GetOptions ('all|a'         => \$all,
            'aux|x=i'       => \$aux,
            'cache|c'       => \$cache,
            'help|h|?'      => \&show_help,
            'origin|o=s'    => \$origin,
            "port|p=s"      => \$port,
            'verbose|v!'   => \$verbose,
            'version|V'     => \&show_version)
    or die("Error in command line arguments!\n");

if ($aux) {
    get_ports();
    exit 0;
}

if ($all) {
    print "Processing all ports ...\n";
    foreach (@origin) {
        print "Processing $_ ... ";
        sleep 1;
        print "done\n";
    }
    exit 0;
}

if (length($port)) {
    print "Processing '$port' ...\n";
    exit 0;
}

__END__
=head1 NAME

portinfo.pl - Provide port information

=head1 SYNOPSIS

portinfo.pl [options] [port ...]

 Options:
   -a, --all        process all ports
   -h, --help       help message
   -o, --origin     process origin
   -p, --port       process port
   -v, --verbose    verbose output
   -V, --version    version information

=head1 DESCRIPTION

portinfo.pl will provide detailed information about installed ports.

=cut

(END)
