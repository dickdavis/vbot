# frozen_string_literal: true

# Copyright 2018 Richard Davis
#
# This file is part of vbot.
#
# vbot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# vbot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with vbot.  If not, see <http://www.gnu.org/licenses/>.

lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
	s.name          = 'vbot'
	s.version       = '0.3.0'
	s.platform      = Gem::Platform::RUBY
	s.authors       = ['Richard Davis']
  s.email         = 'rv@member.fsf.org'
	s.homepage      = 'http://github.com/d3d1rty/vbot'
	s.summary       = 'Ruby library for building IRC bots'
	s.description   = <<~HEREDOC
    vbot is an IRC bot library that aims to be make building and extending IRC bots more efficient.
  HEREDOC
  s.license       = 'GPL-3.0'
  s.files         = Dir['lib/**/*']
  s.test_files    = Dir['test/**/*']
  s.require_path  = ['lib']
end
