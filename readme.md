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
npm install
```


### Running a single feature file:

```console
npx cypress run --headed --no-exit --spec "cypress/integration/tests/chatbot/analytics.feature"
```
**--headed** means that cypress will open a regular headed browser (*)

**--no-exit** means that cypress won't close browser window in the end

_A headless browser is a type of software that can access webpages but does not show them to the user and can pipe 
the content of the webpages to another program_


### Environment requirements
Automation expects that environment contains test record like users,custom questions etc.
See cypress/fixture/envs/readme.md for more details.


### Changing environment(for local development)
If you need to execute tests on a different environment update _baseUrl_ and _env_ fields in **cypress.json** file.
 

### Slow down tests (delay/slowmo)
This can be useful for demo purposes or for educational purposes (e.g. see how to test something)

setup the env var `COMMAND_DELAY` equal to the number of milliseconds to delay each command

This will add a delay of 1 second in between command executions. NOTE env vars are comma separated
```console
cypress run ... --env COMMAND_DELAY=1000,Other_envs=envs_value
```
