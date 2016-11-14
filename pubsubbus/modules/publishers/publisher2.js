//publisher2.js

function init(bus) {
  setInterval(sendData, 1500, bus, 'tsouin-tsouin')
  
  function sendData(bus, text){
    bus.emit('tagada', text)
  }
}

module.exports = {
  init: init,
  name: "tagada emitter 2",
  events: ['tagada']
};