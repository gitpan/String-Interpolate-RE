
on test => sub {

   requires 'Test::More' => 0.98;

};

on develop => sub {

   requires 'Module::Install::AuthorTests';
   requires 'Module::Install::CPANfile';

   requires 'Test::Perl::Critic';
   requires 'Test::Pod::Coverage';
   requires 'Test::Pod';

};

