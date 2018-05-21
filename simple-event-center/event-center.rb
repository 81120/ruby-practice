class EventCenter
  def initialize 
    @events = Hash.new 
  end

  def on event_name, processor
    if @events.key? event_name
      @events[event_name][:processors] << processor
    else
      @events[event_name] = {:processors => [processor]}
    end
  end

  def emit event_name, *params
    processors = @events[event_name][:processors]
    if processors.class != Array 
      return 
    end
    processors.each do |processor| 
      if params.size > 0
        processor.call params
      else
        processor.call
      end
    end
  end

  def off event_name, processor
    if not @events.key? event_name
      return 
    end
    @events[event_name][:processors] = @events[event_name][:processors].reject do |_processor| _processor == processor end 
  end
end

### test code

test = EventCenter.new 
testFunction = lambda do puts 'hello world' end
test.on 't', testFunction
test.emit 't'
