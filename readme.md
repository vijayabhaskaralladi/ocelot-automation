### Environment variables

The test automation project requires Twilio tokens. Set them as env variables before running tests.

**For unix users:**
```console
export TWILIO_ACCOUNT_SID='INSERT_SID_HERE'
export TWILIO_AUTH_TOKEN='INSERT_TOKEN_HERE'
```

**For win users:**

Set System Properties->Advanced->Environment Variables via 'Setting' and restart your computer

### Install all required libraries

```console
npm ci
```

This command will re-use existing package-lock file.

### Running a single feature file:

```console
npx cypress run --headed --no-exit --spec "cypress/integration/tests/chatbot/analytics.feature"
```
**--headed** means that cypress will open a regular headed browser (*)

**--no-exit** means that cypress won't close browser window in the end

_A headless browser is a type of software that can access webpages but does not show them to the user and can pipe 
the content of the webpages to another program_

### Running Lint for js files
Lint output contains code style errors like unused variables, wrong formatting etc. List of 
these rules will be extended in the future. 

Lint for  .js files:
```console
npm run-script lint
```

Lint for *.feature files:
```console
npm run-script lint-bdd
```
Lint for bdd can search for scenario duplicates, empty feature files, formatting issues etc.

### Environment requirements
Automation expects that environment contains test record like users,custom questions etc.
See cypress/fixture/envs/readme.md for more details.


### Changing environment(for local development)
If you need to execute tests on a different environment update _baseUrl_ and _env_ fields in **cypress.json** file.
 

### Code Style
As our project grows we need to pay more attention on code review processes to keep 
project 'easy-to-maintain'. It's essential to think about maintenance and stability before adding 
new features and tests.

**PR requirements:**

* Before adding a new test check that it’s not implemented
* Change list should contain changes related to the current task
* Avoid huge pull requests, 2-3 files and 100 lines of code should be enough for most of tasks
* Use rule - 1 branch per 1 task

**Code requirements:**

* Variables and functions should have ‘self explanatory’ names
* Use camelCase for naming variable, uppercase with underscore for constants and underscore naming for folders
* Check that you don’t duplicate functionality
* Format code using ESLint plugin
* Nice to read:
    * https://www.w3.org/wiki/JavaScript_best_practices
    * https://gist.github.com/wojteklu/73c6914cc446146b8b533c0988cf8d29
    * https://github.com/airbnb/javascript (some parts)
    
**Tests requirements:**

* Before test implementation think what exactly test should check and its value. Test which spends 5 mins and checks 
  only page title isn't a good choice.
* Use validation of dynamic content instead of static where possible checking page title doesn’t 
  guarantee that data was retrieved from backend. It’s better to check page title + check that table/field  is not empty
* Selectors
https://devdocs.magento.com/mftf/docs/guides/selectors.html (scroll to ‘examples’ section)
* Think about how test affects environment - for example if test creates a new provision number each time it will start 
  to fail soon due to limited amount of numbers. Also be careful with records which are used by other tests - if one 
  test modifies something what is used by other test case it will cause failure
* Consistency - doing same things in different ways makes them less readable, it would be nice to use the same approach 
  for the same tasks
* Avoid _Wait X seconds_ step, prefer _Wait_ for some event - network request or presence/absence of an element


### Slow down tests (delay/slowmo)
This can be useful for demo purposes or for educational purposes (e.g. see how to test something)

setup the env var `COMMAND_DELAY` equal to the number of milliseconds to delay each command

This will add a delay of 1 second in between command executions. NOTE env vars are comma separated
```console
cypress run ... --env COMMAND_DELAY=1000,Other_envs=envs_value
```
