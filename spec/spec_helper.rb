Gem::Specification.load(File.dirname(__FILE__)+'/../gemspec').dependencies.each { |dep| gem dep.name, dep.requirement }

$:.unshift File.dirname(__FILE__)+'/../lib'