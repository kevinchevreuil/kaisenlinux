#!/usr/bin/perl -w
# just a little hack to install the man pages in the right directories,
# replacing VERSION with the right version...
use strict;

my @manpages = ("adduser", "adduser.conf", "deluser", "deluser.conf");
my $links;
@{$links->{"adduser"}} = ("addgroup");
@{$links->{"deluser"}} = ("delgroup");

my $version = shift || "VERSION";
my $origdir = shift || "./";
$origdir .= "/" unless($origdir =~ /\/$/);
my $mandir = shift || "/usr/share/man/";
$mandir .= "/" unless($mandir =~ /\/$/);

opendir(DIR, $origdir);
my $file;
foreach $file (readdir(DIR)) {
	next unless(-f $origdir.$file);
	my($language, $page, $section);
	foreach(@manpages) {
		if($file =~ /^$_\.[1-8]/) {
			$page = $_;
			last;
		}
	}
	next unless($page); # this file is not a manpage
	next unless ($section = $file) =~ s/^$page\.([1-8]).*/$1/;
	($language = $file) =~ s/^$page\.$section\.?//;

	my ($destfile, $destdir);
	if($language) {
		$destdir = $mandir.$language."/man".$section;
                $destfile = $destdir."/".$page.".".$section;
		my $relfile = $page.".".$section.".gz";
                if (not -d $destdir) {
                    mkdirs($destdir);
                }
		foreach(@{$links->{$page}}) {
			my $linkfile = $mandir.$language."/man".$section."/".$_.".".$section.".gz";
			printf("Creating symlink from %s to %s...\n", $destfile, $linkfile);
			symlink($relfile, $linkfile);
		}
	} else {
		$destdir = $mandir."/man".$section;
		$destfile = $destdir."/".$page.".".$section;
		my $relfile = $page.".".$section.".gz";
                if (not -d $destdir) {
                    mkdirs($destdir);
                }
		foreach(@{$links->{$page}}) {
			my $linkfile = $mandir."man".$section."/".$_.".".$section.".gz";
			printf("Creating symlink from %s to %s...\n", $destfile, $linkfile);
			symlink($relfile, $linkfile);
		}
	}

	printf("Installing manpage %s%s in %s...\n", $page, $language ? "(".$language.")" : "", $destfile);
	open(IN, "<$origdir$file");
	open(OUT, ">$destfile") or die "can't open $destfile: $!\n";
	while(<IN>) {
		$_ =~ s/VERSION/$version/g;
		print OUT $_;
	}
	close(IN);
	close(OUT);
	printf("Compressing and setting permissions for %s...\n", $destfile);
	system("/bin/gzip", "-9n", $destfile);
	chmod(0644, $destfile.".gz");
}
closedir(DIR);

sub mkdirs {
    my (@dirs) = @_;
    system('install', '-o', 'root', '-g', 'root', '-d', '-m0755', '--', @dirs) == 0
        or die("exec install -d @dirs failed");
}
