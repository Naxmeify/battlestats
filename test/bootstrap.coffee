before (done) ->
  global.App = require '..'
  global.Request = require('supertest') global.App
  
  global.App.bootstrap (err) ->
    global.App.log "Application for test bootstrapped" unless err
    done err

# after (done) ->
#   global.App.stop done
  
describe "BattleStats", ->
  it "should be successfully bootstrapped", ->
    global.App.isBootstrapped.should.be.ok;
    