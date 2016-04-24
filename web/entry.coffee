Primus = require './primus.js'
Rx = require 'rx'

primus = Primus.connect undefined, {manual: true}

deviceOrientationSignal = Rx.Observable.create((o) ->
    window.addEventListener 'deviceorientation', (ev) ->
        o.onNext(ev)
).map((ev) ->
    {
        alpha: ev.alpha
        beta: ev.beta
        gamma: ev.gamma
    }
)

deviceMotionSignal = Rx.Observable.create((o) ->
    window.addEventListener 'devicemotion', (ev) ->
        o.onNext(ev)
).map((ev) ->
    {
        acceleration: ev.acceleration
        accelerationIncludingGravity: ev.accelerationIncludingGravity
    }
)

writerWithType = (primus, type) ->
    return (data) ->
        primus.write {
            type: type
            data: data
        }

primus.on 'open', ->
    console.log 'connection opened'
    primus.write 'hello from client! \\(^_^)/'
    setTimeout(->
        primus.write Math.random()
        , 5000
    )
    deviceOrientationSignal.subscribe(writerWithType(primus, 'deviceOrientationSignal'))
    deviceMotionSignal.subscribe(writerWithType(primus, 'deviceMotionSignal'))

primus.on 'data', (data) ->
    console.log "data from server: #{data}"

primus.open()

alert('start tracking!')
