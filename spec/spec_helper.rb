Gem::Specification.load('gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }
require 'orangutan/mock_adapter'
$:.unshift File.dirname(__FILE__)+'/../lib'