#! /usr/bin/ruby

require 'gst'
require 'ipaddr'
Gst.init

RTP_PAYLOAD = 96
RTP_CONFIG_INTERVAL = 5

RPICAM_PREVIEW = false
RPICAM_PREVIEW_OPACITY = 128
RPICAM_BITRATE = 20000000
RPICAM_WIDTH = 640
RPICAM_HEIGHT = 480
RPICAM_FRAMERATE = "30/1"
RPICAM_CAPS = "video/x-h264, width=#{RPICAM_WIDTH}, height=#{RPICAM_HEIGHT}, framerate=#{RPICAM_FRAMERATE}"


class VideoStreamer

  def initialize(ip, port)
    ## Instanciate main objects
    # GLib main loop
    puts "Generate GLib2 main loop"
    @mainloop = GLib::MainLoop.new(GLib::MainContext.default, true)

    # GSTreamer Pipeline
    puts "Generate GSTreamer pipeline"
    @pipeline = Gst::Pipeline.new("Streamer")
    raise "'pipeline' gstreamer plugin missing" if @pipeline.nil?

    #@source2=Gst::ElementFactory.make("videotestsrc")
    #@gdppay2=Gst::ElementFactory.make("gdppay")
    #@gdppay3=Gst::ElementFactory.make("gdppay")
    #@x264enc=Gst::ElementFactory.make("x264enc")
    #@mpegtsmux=Gst::ElementFactory.make("mpegtsmux")
    #@sink2=Gst::ElementFactory.make("tcpserversink")
    #@sink2.host="192.168.1.145"
    #@sink2.port=5000
    #@sink2.sync_method=2
    #@sink2.enable_last_sample=false
    #@queue=Gst::ElementFactory.make("queue")
    #@sink2=Gst::ElementFactory.make("autovideosink")
    #add_watches
    
    @source=Gst::ElementFactory.make("tcpclientsrc")
    @source.host="192.168.1.14fwef5"
    @source.port=5000

    @gdpdepay=Gst::ElementFactory.make("gdpdepay")

    @sink=Gst::ElementFactory.make("fpsdisplaysink")

    @pipeline.add @source, @gdpdepay, @sink
    @source >> @gdpdepay
    return


    ## Create all elements
    # source: uses rpicam wrapper that can be found here https://github.com/thaytan/gst-rpicamsrc
    # another solution may be to use fdsrc and take raspivid output through stdin.
    puts "Generate rpicamsrc (source) element"
    @source = Gst::ElementFactory.make("rpicamsrc")
    raise "'rpicamsrc' gstreamer plugin missing (see https://github.com/thaytan/gst-rpicamsrc)" if @source.nil?

    print "- Preview? "
    puts @source.preview = RPICAM_PREVIEW
    print "- Opacity? "
    puts @source.preview_opacity = RPICAM_PREVIEW_OPACITY
    print "- Bitrate? "
    puts @source.bitrate = RPICAM_BITRATE

    # caps: Capacity negotiation with rpicamsrc to set width, height and other parameters
    puts "- Adding following 'capacities' to rpicamsrc: #{RPICAM_CAPS}"
    @caps = Gst::Caps.from_string(RPICAM_CAPS)

    @source.set_caps @caps

    # h264parse: parse raw h264 stream provided by raspivid
    puts "Generate h264parse element"
    @h264parse = Gst::ElementFactory.make("h264parse")
    raise "'h264parse' gstreamer plugin missing" if @h264parse.nil?    
    
    # rtph264pay: add RTP payload to enable RTP streaming
    puts "Generate rtph264pay element"
    @rtph264pay = Gst::ElementFactory.make("rtph264pay")
    raise "'rtph264pay' gstreamer plugin missing" if @rtph264pay.nil?

    print "- RTP Payload: "
    puts @rtph264pay.pt = RTP_PAYLOAD
    print "- RTP Config Interval: "
    puts @rtph264pay.config_interval = RTP_CONFIG_INTERVAL

    # gdppay: add payload to allow streaming over TCP. Do not put for UDP.
    puts "Generate gdppay element"
    @gdppay = Gst::ElementFactory.make("gdppay")
    raise "'gdppay' gstreamer plugin missing" if @gdppay.nil?

    # tcpsink: listen for TCP connection to send the RTP stream
    puts "Generate tcpserversink (sink) element"
    @sink = Gst::ElementFactory.make("tcpserversink")
    raise "'tcpserversink' gstreamer plugin missing" if @sink.nil?

    print "- Binding to IP: "
    puts @sink.host = ip
    print "- Listening to TCP port: "
    puts @sink.port = port


    ## Create the pipeline
    #@pipeline.add @source, @h264parse, @rtph264pay, @sink
    puts "Add elements to the pipeline"
    @pipeline.add @source, @h264parse, @rtph264pay, @gdppay, @sink
    @source >> @h264parse

    #add_watches

  end


  def add_watches

    # Add watches to handle errors and EOS gracefully
    puts "Add watches to pipeline bus"
    @pipeline.bus.add_watch do | bus, message |
      case message.type
        when Gst::MessageType::ERROR
          $stderr.puts "Pipeline Error:"
          $stderr.puts "=========================================="
          $stderr.puts message.parse_error
          $stderr.puts "=========================================="
          @mainloop.quit
          exit 1

        when Gst::MessageType::EOS
          @pipeline.stop
          @mainloop.quit
          exit 0
      end
      true
    end

  end

  ## Launch the stream
  def stream
    @pipeline.play
    @mainloop.run
  end

  ## Stop the pipeline gracefully
  def stop
    @pipeline.stop
  end

end

def usage
  puts "Usage: #{__FILE__} dest_ip dest_port"
  puts " dest_ip: destination IP, in format 128.64.32.16"
  puts " dest_port: destination port, integer between 1 and 62335" 
  exit 2
end

## DEBUG
ENV["GST_DEBUG"]="5"


## Check arguments
# Number of arguments is not 2
usage if ARGV.length != 2
# IP in correct format
begin
  IPAddr.new ARGV[0]
rescue
  usage
end

# Port number is not in the range 1-62335
usage if (ARGV[1].to_i < 1) or (ARGV[1].to_i > 62335)

## Create the streamer instance
puts "Create Stream Instance"
streamer = VideoStreamer.new ARGV[0], ARGV[1].to_i



## Launches the stream
begin
  puts "Start streaming"
  streamer.stream
  puts "Stream ended without interruption nor errors (strange with raspivid !)"
rescue Interrupt
  puts "Ctrl+C pressed"
ensure
  streamer.stop
  puts "Stream stopped... goodbye..."
end
