Gem::Specification.new do |spec|
  spec.name = 'shh'
  spec.version = '0.3.0'
  spec.summary = "command line utility for managing secure information"
  spec.description = <<-EOF
A command line utility that manages accounts and passwords as individual encypted files
EOF
  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/shh'
  spec.files = Dir['lib/**/*'] + Dir['spec/**/*'] + Dir['bin/*'] + ['README.rdoc', 'MIT-LICENSE', 'HISTORY.rdoc', 'Rakefile', '.gemtest']
  spec.executables << 'shh'

  spec.add_dependency 'flat_hash', '~>0'
  spec.add_dependency 'highline', '~>1.6'
  spec.add_dependency 'uuidtools', '~>2'
  spec.add_dependency 'splat', '~>0'
  spec.add_dependency 'shell_shock', '~>0'
  spec.add_dependency 'activesupport', '~>3'
  spec.add_dependency 'i18n', '~>0'
  spec.add_dependency 'crypt19', '~>1'

  spec.add_development_dependency 'rake', '~>0.8'
  spec.add_development_dependency 'rspec', '~>2'
end
