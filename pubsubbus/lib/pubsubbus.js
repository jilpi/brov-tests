var events = require('events')

var publishers = {}
var subscribers = {}


function Pubsubbus(busType){
  // If not specified, default type is 'events'
  switch (busType){
    case 'events':
    case undefined:
      this.bus = new events.EventEmitter
      this.busType = 'events'
      break
    default:
      throw new Error('pubsubbus.constructor: unknown bus type (' + busType + ')')
  }
}

Pubsubbus.prototype = {
  getAvailableDevices: getAvailableDevices,
  registerDevices: registerDevices,
  registerDevice: registerDevice
}

function getAvailableDevices(){
  // TODO: IMPLEMENT FUNCTION
  var dummyDevice1 = {
    model: 'tagadasinger',
    id: 'tagadasinger-1'
  }

  var dummyDevice2 = {
    model: 'tagadasinger',
    id: 'tagadasinger-2'
  }
  
  var dummyDevice3 = {
    model: 'tagadalistener',
    id: 'tagadalistener-1'
  }

  return [dummyDevice1, dummyDevice2, dummyDevice3]
}

function registerDevices(devices){
  // TODO: IMPLEMENT FUNCTION
  console.log('registering %s devices', devices.length.toString())
  devices.forEach(function (element, index, array) { 
    registerDevice(element)
  })
}

function registerDevice(device){
  // TODO: IMPLEMENT FUNCTION
  console.log('registering: %s', JSON.stringify(device))
}

a = new Pubsubbus()
a.registerDevices(a.getAvailableDevices())

/* function registerPublisher
  Registers an publisher on the bus.
  
  publisherName: string, name of the module
  publisherPath: string, path to the module (excluding .js extension eg. "./modules/publisher")
*/
// Pubsubbus.prototype.registerPublisher = function(publisherName, publisherPath){
//   publishers[publisherName] = require(publisherPath)
//   publishers[publisherName].init(bus)
// }

/* function registerSubscriber
  Registers an subscriber on the bus.
  
  subscriberName: string, name of the module
  subscriberPath: string, path to the module (excluding .js extension eg. "./modules/subscriber")
*/
// Pubsubbus.prototype.registerSubscriber = function(subscriberName, subscriberPath){
//   subscribers[subscriberName] = require(subscriberPath)
//   subscribers[subscriberName].init(bus)
// }

// register all publishers
// code to be replaced by a more elegent solution (modules autodetection by browsing file system)
// var publishersList = ['publisher1', 'publisher2']
// var publishersLocation = './modules/'
// publishersList.forEach(function(element, index, array){
//   registerPublisher(element, publishersLocation + element)
// })


// register all subscribers
// code to be replaced by a more elegent solution (modules autodetection by browsing file system)
// var subscribersList = ['subscriber1']
// var subscribersLocation = './modules/'
// subscribersList.forEach(function(element, index, array){
//   registerSubscriber(element, subscribersLocation + element)
// })

