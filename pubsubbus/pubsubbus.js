var events = require('events')
var bus = new events.EventEmitter
var publishers = {}
var subscribers = {}

/* function registerPublisher
  Registers an publisher on the bus.
  
  publisherName: string, name of the module
  publisherPath: string, path to the module (excluding .js extension eg. "./modules/publisher")
*/
function registerPublisher(publisherName, publisherPath){
  publishers[publisherName] = require(publisherPath)
  publishers[publisherName].init(bus)
}

/* function registerSubscriber
  Registers an subscriber on the bus.
  
  subscriberName: string, name of the module
  subscriberPath: string, path to the module (excluding .js extension eg. "./modules/subscriber")
*/
function registerSubscriber(subscriberName, subscriberPath){
  subscribers[subscriberName] = require(subscriberPath)
  subscribers[subscriberName].init(bus)
}

// register all publishers
// code to be replaced by a more elegent solution (modules autodetection by browsing file system)
var publishersList = ['publisher1', 'publisher2']
var publishersLocation = './modules/'
publishersList.forEach(function(element, index, array){
  registerPublisher(element, publishersLocation + element)
})


// register all subscribers
// code to be replaced by a more elegent solution (modules autodetection by browsing file system)
var subscribersList = ['subscriber1']
var subscribersLocation = './modules/'
subscribersList.forEach(function(element, index, array){
  registerSubscriber(element, subscribersLocation + element)
})

