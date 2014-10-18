require 'win32ole'
class IERunner
  attr_reader :app
  def initialize
    @type = WIN32OLE_TYPE.new("Microsoft Internet Controls", "InternetExplorer")
    @app = WIN32OLE.new("InternetExplorer.Application")
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
end
