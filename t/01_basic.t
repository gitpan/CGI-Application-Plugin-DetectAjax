use Test::More tests => 3;
BEGIN { use_ok('CGI::Application::Plugin::DetectAjax'); };


use lib './t';
use strict;

use CGI;
use Test::MockObject;
use Test::MockObject::Extends;

eval "use CGI";
plan skip_all => "CGI required for test" if $@;

eval "use Test::MockObject";
plan skip_all => "Test::MockObject required for test" if $@;

eval "use Test::MockObject::Extends";
plan skip_all => "Test::MockObject::Extends required for test" if $@;

$ENV{CGI_APP_RETURN_ONLY} = 1;

use TestAppBasic;
my $t1_obj = TestAppBasic->new();
my $t1_output = $t1_obj->run();

is($t1_obj->is_ajax, 0);


# create an object to mock
my $cgi      = CGI->new();
$cgi         = Test::MockObject::Extends->new( $cgi );
$cgi->mock( 'http', sub { 'xmlhttprequest'  });

my $object = Test::MockObject::Extends->new( $t1_obj);
$object->mock('cgiapp_get_query', sub { $cgi });
$object->mock('query', sub { $cgi });


is($object->is_ajax, 1);
