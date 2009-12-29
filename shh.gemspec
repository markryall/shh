Gem::Specification.new do |spec|
  spec.name = 'shh'
  spec.version = '0.1.2'
  spec.summary = "command line utility for managing secure information"
  spec.description = <<-EOF
A command line utility that manages accounts and passwords as individual encypted files
EOF
 
  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/shh'
 
  spec.files = Dir['lib/**/*'] + Dir['bin/*'] + ['README.rdoc', 'MIT-LICENSE']
  spec.executables << 'shh'
 
  spec.add_dependency 'highline', ['~>1.5.1']
  spec.add_dependency 'uuidtools', ['~>2.1.1']
  spec.add_dependency 'crypt', ['~>1.1.4']
  spec.add_dependency 'pathname2', ['~>1.6.3']
end
