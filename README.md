# README

This is a small Rails tool which I use to keep track of whom I owe and who owes me money at the moment.

### Ruby Version

Loan manager makes use of Ruby v.2.6.3.

### Dependencies & Explanation

In addition to the regular Dependencies a Rails application comes with, Loan Manager makes use of the following gems:
* sitemap_generator (SEO; showcase)
* byebug (Debugger)
* rspec-rails (as replacement for minitest)
* factory_bot_rails (to generate fixtures on the fly)
* faker (to generate random fake data if needed)
* database_cleaner-active_record (to speeden up the tests by rolling back database changes after each spec)

### Usage

To use the loan manager, just create an account by signing up. Afterwards you may log in with the credentials you used.

If there's need for an Admin account, open the console and run the following:

```User.find(<your user id>).switch_admin_access!```

### Tests

The test suite can be run via

```bundle exec rspec```