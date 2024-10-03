// helloWorld.test.js
const helloWorld = require('./helloWorld.js');

test('helloWorld function returns "Hello, World!"', () => {
  expect(helloWorld()).toBe("Hello, World!");
});
