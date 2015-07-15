//emitter1.js

function init(bus) {
  bus.on('tagada', print)
}

function print(data){
  console.log(data)
}

module.exports = {
  init: init,
  name: "tagada listener 1",
  events: ['tagada']
  
};
