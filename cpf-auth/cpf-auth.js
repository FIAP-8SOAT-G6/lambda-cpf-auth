exports.handler = async (event) => {
  const jwt = require('jsonwebtoken');

  // Secret key
  // TODO: const secret = process.env.JWT_SECRET;
  const secret = 'BEATLES';

  // TODO: Get user info
  const payload = {
    admin: false
  };

  // Generate token
  const token = jwt.sign(payload, secret, { expiresIn: '1h' });

  console.log('Generated Token:', token);

  return token
}
