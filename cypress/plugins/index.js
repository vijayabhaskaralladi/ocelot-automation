const cucumber = require('cypress-cucumber-preprocessor').default;

module.exports = (on) => {
  const TWILIO_ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID;
  const TWILIO_AUTH_TOKEN = process.env.TWILIO_AUTH_TOKEN;
  const client = require('twilio')(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);

  require('cypress-log-to-output').install(on, (type, event) => {
    return event.level === 'error' || event.type === 'error';
  });

  on('task', {
    generateOTP: require('cypress-otp'),
    log(msg) {
      // cy.log prints logs in the browser window only
      // if test fails on CI we have access only to a screenshot and a few logs from the screenshot
      // using cy.task('log', 'My Log Message') will keep this message in console logs
      // cy.task() - runs inside node process, console.log will print to the terminal
      // cy.command() - runs in the browser window, console.log will print log to the browser console
      console.log(`[${new Date().toLocaleTimeString()}]: ${msg}`);
      return null;
    },
    sendSms(data) {
      client.messages
        .create({
          from: data.fromNumber,
          body: data.message,
          to: data.toNumber,
        })
        .done();
      return null;
    },
    async verifyThatNumberReceivedSms(data) {
      const sleep = (delay) =>
        new Promise((resolve) => {
          setTimeout(resolve, delay);
        });
      const delay = 3000;
      let retries = 5;
      const inboxFilter = (msg) =>
        msg.body.includes(data.message) && msg.errorCode === null && msg.direction === 'inbound';

      let inbox = [];
      let isMessageFound = false;
      while (retries >= 0 && !isMessageFound) {
        retries -= 1;
        await sleep(delay);
        const inboxAll = await client.messages.list({
          to: data.number,
          limit: 2,
        });
        const filteredInbox = inboxAll.filter(inboxFilter);
        if (filteredInbox.length === 1) {
          isMessageFound = true;
          inbox = filteredInbox;
        }
      }
      return inbox;
    },
    async getLastIncomingSmsForNumber(number) {
      const inbox = await client.messages.list({
        to: number,
        limit: 5,
      });

      return inbox.find((msg) => msg.direction === 'inbound');
    },
  });
  on('file:preprocessor', cucumber());
};
