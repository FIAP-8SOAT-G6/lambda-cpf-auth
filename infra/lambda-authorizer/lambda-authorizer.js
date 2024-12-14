const jwt = require('jsonwebtoken');

exports.handler = async (event) => {
  console.log('Received event:', JSON.stringify(event, null, 2));

  const token = event.headers.Authorization || event.headers.authorization;
  if (!token) {
    return generatePolicy('Deny', event.methodArn);
  }

  try {
    const secret = 'BEATLES';
    const decoded = jwt.verify(token.replace('Bearer ', ''), secret);

    console.log('Decoded token:', decoded);

    return generatePolicy('Allow', event.methodArn, decoded.sub);
  } catch (err) {
    console.error('Token verification failed:', err);
    return generatePolicy('Deny', event.methodArn);
  }
};

function generatePolicy(effect, resource, principalId = 'user') {
  return {
    principalId,
    policyDocument: {
      Version: '2012-10-17',
      Statement: [
        {
          Action: 'execute-api:Invoke',
          Effect: effect,
          Resource: resource,
        },
      ],
    },
  };
}
