require 'win32ole'
require 'event_handler'

class IERunner
  attr_reader :app

  def initialize
    @type = WIN32OLE_TYPE.new("Microsoft Internet Controls", "InternetExplorer")
    @app = WIN32OLE.new("InternetExplorer.Application")
    @ev_handler = EventHandler.new
    @run_loop = true

    @app_event = WIN32OLE_EVENT.new(@app)
    @app_event.handler = @ev_handler

    @ev_handler.add_handler("OnQuit") {|*args| exit_message_loop}
    @ev_handler.add_handler("DocumentComplete") do |*args|
      unless @app.document.body.innerHTML.empty?
        @doc_event = WIN32OLE_EVENT.new(@app.document)
        @doc_event.handler = @ev_handler
      end
    end
    @document_complete = false
    @ev_handler.add_handler("DocumentComplete") do |*args|
      @document_complete = true
      unless @app.document.body.innerHTML.empty?
        @doc_event = WIN32OLE_EVENT.new(@app.document)
        @doc_event.handler = @ev_handler
      end
    end
    @ev_handler.add_handler("BeforeNavigate2") {|*args| @document_complete = false}
  end

  def register_handler(event, &block)
    @ev_handler.add_handler(event, &block) unless event == 'OnQuit'
  end

  def wait_complete(secs, interval = 0.5)
    elapsed = 0
    while(!@document_complete && elapsed <= secs)
      elapsed += interval
      sleep(interval)
      WIN32OLE_EVENT.message_loop
    end
  end

  def exit_message_loop
    puts "IE exiting..."
    @run_loop = false
  end

  def run
    while(@run_loop)
      WIN32OLE_EVENT.message_loop
    end
  end

  def guid
    @type.guid
  end

  def progid
    @type.progid
  end

  def visible=(is_visible)
    @app.visible = is_visible
  end

  def goto(url)
    @app.Navigate(url)
  end

  def close
    @app.Quit
  end

  def html
    @app.document.nil? ? '' : @app.document.body.outerHTML
  end

  def element_by_id(id)
    return @app.document.getElementById(id.to_s) unless @app.document.nil?
  end

  def elements_by_name(name)
    return @app.document.getElementsByName(name.to_s) unless @app.document.nil?
  end

  def elements_by_tag(tag)
    return @app.document.getElementsByTagName(tag.to_s) unless @app.document.nil?
  end

  def click(id)
    elem = element_by_id(id)
    elem.click unless elem.nil?
  end

  def fill_text(id, value)
    elem = element_by_id(id)
    elem.value = value unless elem.nil?
  end

  def set_check_box(id, value = true)
    elem = element_by_id(id)
    elem.checked = value unless elem.nil?
  end

  def select_index(id, idx)
    elem = element_by_id(id)
    elem.selectedIndex = idx unless elem.nil?
  end

  def child_with_attrib_value(parent, attrib, value)
    if parent && parent.hasChildNodes
      parent.childNodes.each do |cn|
        begin
          return cn if cn.send(attrib) == value
        rescue
        end
      end
    end
  end

end
