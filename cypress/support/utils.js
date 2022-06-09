const ENVIRONMENT_NAME = Cypress.config().baseUrl.slice(8, -1);
exports.ENVIRONMENT_NAME = ENVIRONMENT_NAME;

// retrieves nested value from JSON object using string path
export const getValueByPath = (object, path) => path.split('.').reduce((r, k) => r[k], object);

export const convertDataTableIntoDict = (datatable) => {
  // Converts data tables into dict
  // [[key1, val1], [key2,val2],...]
  // { key1: val1, key2: val2 }

  const pairs = datatable.rawTable;
  const dict = {};
  for (let i = 0; i < pairs.length; i++) {
    const key = pairs[i][0];
    const val = pairs[i][1];
    dict[key] = val;
  }
  return dict;
};

const YES_RESPONSES_FOR_CAMPAIGNS = [
  'Y',
  'yes',
  'yes please',
  'yeah',
  'yep',
  'sure',
  'of course',
  'ya',
  'yup',
  'totally',
  'ya mon',
  'you bet',
  'ok',
  'k',
  'okay',
  'okie dokie',
  'sounds good',
  'for sure',
  'sure thing',
  'certainly',
  'definitely',
  'gladly',
  'absolutely',
  'indeed',
  'undoubtedly',
  'affirmative',
  'uh-huh',
];
exports.YES_RESPONSES_FOR_CAMPAIGNS = YES_RESPONSES_FOR_CAMPAIGNS;

const NO_RESPONSES_FOR_CAMPAIGNS = [
  'no',
  'no thanks',
  'nope',
  'never',
  'i don’t think so',
  'nah',
  'decline',
  'absolutely not',
  'no way',
  'negative',
  'nay',
  'not by any means',
  'certainly not',
  'of course not',
  'absolutely not',
  'definitely not',
];
exports.NO_RESPONSES_FOR_CAMPAIGNS = NO_RESPONSES_FOR_CAMPAIGNS;
