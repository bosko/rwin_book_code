class EventHandler
  def initialize
    @handlers = {}
  end

  def add_handler(event, &block)
    if block_given?
      @handlers[event] = block
    end
  end

  def method_missing(event, *args)
    if @handlers[event.to_s]
      @handlers[event.to_s].call(*args)
    end
  end
end
