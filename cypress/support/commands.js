/**
 * @description adds a delay between all test commands so viewers can see what is happening
 * @see {@link https://github.com/cypress-io/cypress/issues/249#issuecomment-670028947}
 * @example usage to add a 1 second delay between commands
 * cypress open --env COMMAND_DELAY=1000,Other_envs=envs_value
 */
const COMMAND_DELAY = Cypress.env('COMMAND_DELAY') || 0;
if (COMMAND_DELAY > 0) {
  const COMMANDS = ['visit', 'click', 'trigger', 'type', 'clear', 'reload', 'contains'];
  for (const command of COMMANDS) {
    Cypress.Commands.overwrite(command, (originalFn, ...args) => {
      const origVal = originalFn(...args);

      return new Promise((resolve) => {
        setTimeout(() => {
          resolve(origVal);
        }, COMMAND_DELAY);
      });
    });
  }
}
