Primus = require './primus.js'

primus = Primus.connect undefined, {manual: true}

primus.on 'open', ->
    console.log 'connection opened'
    primus.write 'hello from client! \\(^_^)/'
    setTimeout(->
        primus.write Math.random()
        , 5000
    )

primus.on 'data', (data) ->
    console.log "data from server: #{data}"

primus.open()
