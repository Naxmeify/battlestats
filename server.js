var app = require('./');
app.start({}, function(error) {
  if(error) {
    console.error(error);
  } else {
    app.log('Server running on ' + app.config.host);
  }
});

process.on('exit', function() {
  app.stop();
});