Gem::Specification.load(File.dirname(__FILE__)+'/../gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

require 'orangutan/mock_adapter'

$:.unshift File.dirname(__FILE__)+'/../lib'