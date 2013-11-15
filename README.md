BrowBeat
===
[![Build Status](http://jenkins.library.nyu.edu/buildStatus/icon?job=BrowBeat)](http://jenkins.library.nyu.edu/job/BrowBeat/)

BrowBeat testing suite tests all major functions of BobCat, across its myriad systems,
and is intended to be used in a continuous integration workflow whereby anytime code is updated for
any BobCat system, the automated testing suite runs to verify functionality across the system remains
intact.

Running Tests
---
To run the BrowBeat, first use bundler.

    $ bundle install

Then run the tests.

    $ bundle exec rake test
    
Or for parallel tests, replace 20 with any number

    $ bundle exec parallel_test -n 20 lib/ 
    
Writing Tests
---
In order to contribute tests to this project

1. Fork it.
2. Add/upate a module with your tests in it.
3. Include the module in one of the \_test.rb classes if it's not already included (primo_test.rb for now).
4. Submit a pull request.

Documentation
---
[Documentation](http://nyulibraries.github.com/bobcat_automated_tests/rdocs/) for working with the BobCat Automated Tests can be helpful in determining which methods to use.

__This documentation is outdated, stay tuned for revamped docs.__

BobCat Systems
---
BobCat is made up of a variety of systems.  All BobCat systems will be included in the testing suite.

1. Primo (Books & More, Course Reserves) 
2. Aleph (BobCat Standard, Holdings/Request Pages)
3. Umlaut (GetIt, E-Journals A-Z)
4. Xerxes (Articles & Databases, Databases A-Z )
5. ILLiad (Interlibrary Loan)
6. PDS (Single Sign-on)
7. Tsetse (E-Shelf)
8. Apache Solr (Finding Aids)

Platforms/Browsers Tested
---
The BobCat automated testing suite can test the following platforms and browsers.  

Checkout what [SauceLabs supports](https://saucelabs.com/docs/browsers).  
We're testing a [subset](https://github.com/NYULibraries/nyulibraries_browbeat/blob/master/config/sauce_labs_platforms.yml).

GNU IP Testing
---
Testing machines will be set up in GNU locations that will allow remote testing from GNU IPs
to ensure compatibility.

The testing machines will need to have Selenium Server installed on them. [Download](http://selenium.googlecode.com/files/selenium-server-standalone-2.25.0.jar)

The testing platforms/browsers tested will be the two most popular platform/browser combinations
for GNU IP ranges.

Continuous Integration
---
BrowBeat is intended to be automatically launched via Jenkins, 
the NYU Libraries continuous integration tool. The BrowBeat project
can be made a post build action in Jenkins for all BobCat systems.

The process will be:

1.  Merge/rebase a development branch into master and push to GitHub for a BobCat system
2.  The GitHub master push triggers Jenkins to build (running relevant unit tests along the way)
    and deploy (using Capistrano and an Execute Shell build step) the system.
3.  A post build action is triggered on the Jenkins job that runs the BobCat automated test suite.
4.  If the BobCat automated test suite passes, do nothing, the build is successful.  
    If it fails, roll back. (Still need to determine Jenkins mechanism to actually do this.)
