//publisher1.js

function init(bus) {
  setInterval(sendData, 500, bus, 'tagada')
  
  function sendData(bus, text){
    bus.emit('tagada', text)
  }
}

module.exports = {
  init: init,
  name: "tagada emitter 1",
  events: ['tagada']
  
};
