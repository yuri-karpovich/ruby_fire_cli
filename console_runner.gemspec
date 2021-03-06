# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_fire_cli/version'

Gem::Specification.new do |spec|
  spec.name    = 'ruby_fire_cli'
  spec.version = RubyFireCLI::VERSION
  spec.authors = ['Yury Karpovich']
  spec.email   = %w(spoonest@gmail.com yuri.karpovich@gmail.com)

  spec.summary     = 'Command-line runner for ruby code.'
  spec.description = 'This gem provides you an ability to run any Ruby method ' \
    'from command-line (no any code modifications required!!!)'
  spec.homepage    = 'https://github.com/yuri-karpovich/ruby_fire_cli'
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = ['rcli']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency /rake", ">= 12.3.3'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry', '~> 0'
  spec.add_development_dependency 'simplecov', '~> 0'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_dependency 'trollop', '~> 2.1'
  spec.add_dependency 'yard', '~> 0.9'
  spec.add_dependency 'colorize', '~> 0.8'
end
