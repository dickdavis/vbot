# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
	s.name          = 'vbot'
	s.version       = '0.1.1'
	s.platform      = Gem::Platform::RUBY
	s.authors       = ["Richard Davis"]
	s.email         = 'dick@sbdsec.com'
	s.homepage      = 'http://github.com/d3d1rty/vbot'
	s.summary       = 'vbot is an IRC bot library'
	s.description   = <<-EOF 
vbot is an IRC bot library that aims to be make building and extending IRC bots more efficient.
EOF
	s.license       = 'LGPL-2.1'
	s.files         = ['lib/vbot.rb',
                     'lib/vbot/base.rb',
                     'lib/vbot/vbotcontroller.rb',
                     'lib/vbot/vbotmsglogic.rb']
	s.executables   = ['vbot']
	s.test_files    = ['test/test_vbot.rb']
	s.require_path  = ['lib']
end
