# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
	s.name          = 'verboten'
	s.version       = '0.1.0'
	s.platform      = Gem::Platform::RUBY
	s.authors       = ["Richard Davis"]
	s.email         = 'dick@sbdsec.com'
	s.homepage      = 'http://github.com/d3d1rty/verboten'
	s.summary       = 'verboten is an IRC bot library'
	s.description   = <<-EOF 
verboten is an IRC bot library that aims to be make building and extending IRC bots more efficient.
EOF
	s.license       = 'LGPL-2.1'
	s.files         = ['lib/verboten.rb',
                     'lib/verboten/base.rb',
                     'lib/verboten/vbotcontroller.rb',
                     'lib/verboten/vbotmsglogic.rb']
	s.executables   = ['verboten']
	s.test_files    = ['test/test_verboten.rb']
	s.require_path  = ['lib']
end
