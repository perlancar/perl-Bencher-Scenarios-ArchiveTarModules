package Bencher::ScenarioUtil::ArchiveTarModules;

# DATE
# VERSION

use 5.010_001;
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
);

1;
# ABSTRACT: Utility routines
