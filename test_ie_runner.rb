require './ie_runner'
ie = IERunner.new
ie.visible = true
ie.goto "http://www.rubyinstaller.org"
sleep(5)
ie.close
