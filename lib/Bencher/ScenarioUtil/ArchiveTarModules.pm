package Bencher::ScenarioUtil::ArchiveTarModules;

# DATE
# VERSION

use strict;
use warnings;

use File::ShareDir 'dist_dir';

our @Datasets = do {
    my @res;
    my $path;

    {
        $path = "share/archive.tar.gz";
        last if -f $path;
        $path = dist_dir("Bencher-Scenarios-ArchiveTarModules");
    }
    push @res, {
        name    => 'archive.tar.gz',
        summary => 'Sample archive with 10 files, ~10MB each',
        args    => {filename=>$path},
    };

    @res;
};

our %Modules = (
    'Archive::Tar' => {
        description => <<'_',

Archive::Tar is a core module. It reads the whole archive into memory, so care
should be taken when handling very large archives.

_
        code_template_list_files => <<'_',
            my $filename = <filename>;
            my $obj = Archive::Tar->new;
            my @files = $obj->read($filename);
            my @res;
            for my $file (@files) {
                push @res, {
                    name => $file->name,
                    size => $file->size,
                };
            }
            return @res;
_
    },

    'Archive::Tar::Wrapper' => {
        description => <<'_',

Archive::Tar::Wrapper is an API wrapper around the 'tar' command line utility.
It never stores anything in memory, but works on temporary directory structures
on disk instead. It provides a mapping between the logical paths in the tarball
and the 'real' files in the temporary directory on disk.

_
        code_template_list_files => <<'_',
            my $filename = <filename>;
            my $obj = Archive::Tar::Wrapper->new;
            my @res;
            $obj->list_reset;
            while (my $entry = $obj->list_next) {
                my ($tar_path, $phys_path) = @$entry;
                push @res, {
                    name => $tar_path,
                    size => (-s $phys_path),
                };
            }
            return @res;
_
    },
);

1;
# ABSTRACT: Utility routines
