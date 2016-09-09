package Bencher::Scenario::ArchiveTarModules::ListMemUsage;

# DATE
# VERSION

use Bencher::ScenarioUtil::ArchiveTarModules;

my $modules  = \%Bencher::ScenarioUtil::ArchiveTarModules::Modules;
my $datasets = \@Bencher::ScenarioUtil::ArchiveTarModules::Datasets;

our $scenario = {
    summary => 'Benchmark memory usage for listing files of an archive',
    modules => {
    },
    participants => [
        (map {
            my $spec = $modules->{$_};
            +{
                name => $_,
                module => $_,
                description => $spec->{description},
                code_template => $spec->{code_template_list_files},
            };
        } keys %$modules),

        {
            name => 'perl (baseline)',
            code_template => '1',
        },
    ],
    datasets => $datasets,
    with_process_size => 1,
    precision => 6,
};

1;
# ABSTRACT:

=head1 SEE ALSO
