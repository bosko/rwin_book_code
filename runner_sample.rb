$LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'ie_runner'

ier = IERunner.new
ier.visible = true
ier.goto "http://www.google.com/language_tools"
ier.wait_complete(30)

ier.fill_text("source", "Interesantan primer")
ier.element_by_id("gt-submit").click
