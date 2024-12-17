exports.handler = async (event) => {
  const jwt = require('jsonwebtoken');

  console.log("asdasd")
  // Secret key
  const secret = 'BEATLES';

  // TODO: Get user info
  const payload = {
    sub: '1234567890', // User CPF or identier
    name: 'John Lennon',
    admin: false,
  };

  // Generate token
  const token = jwt.sign(payload, secret, { expiresIn: '1h' });

  console.log('Generated Token:', token);

  return token
}
