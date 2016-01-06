module.exports.session = 
  name: 'bico.sid'
  secret: process.env.SESSION_SECRET or 'battlestats.session.secret'
  resave: true # TODO check for problems in future
  saveUninitialized: true