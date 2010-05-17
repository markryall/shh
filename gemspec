Gem::Specification.new do |spec|
  spec.name = 'shh'
  spec.version = '0.1.7'
  spec.summary = "command line utility for managing secure information"
  spec.description = <<-EOF
A command line utility that manages accounts and passwords as individual encypted files
EOF
  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/shh'
  spec.files = Dir['lib/**/*'] + Dir['bin/*'] + ['README.rdoc', 'MIT-LICENSE']
  spec.executables << 'shh'

  spec.add_dependency 'highline', '~>1.5.2'
  spec.add_dependency 'uuidtools', '~>2.1.1'
  spec.add_dependency 'crypt', '~>1.1.4'
  spec.add_dependency 'splat', '~>0.1.0'
  spec.add_dependency 'shell_shock', '~>0.0.2'

  spec.add_development_dependency 'rake', '~>0.8.7'
  spec.add_development_dependency 'gemesis', '~>0.0.3'
end
