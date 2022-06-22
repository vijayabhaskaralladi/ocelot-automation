const cucumber = require('cypress-cucumber-preprocessor').default;

module.exports = (on) => {
  const TWILIO_ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID;
  const TWILIO_AUTH_TOKEN = process.env.TWILIO_AUTH_TOKEN;
  const client = require('twilio')(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);

  on('task', {
    generateOTP: require('cypress-otp'),
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
