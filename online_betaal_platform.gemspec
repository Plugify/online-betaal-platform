require File.expand_path('../lib/online_betaal_platform/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'online_betaal_platform'
  spec.version       = OnlineBetaalPlatform::VERSION
  spec.authors       = ['Mamoun Saudi']
  spec.email         = ['aqabawe@gmail.com']

  spec.summary       = 'API Wrapper for Online Betaal Platform'
  spec.description   = 'API Wrapper for Online Betaal Platform'
  spec.homepage      = 'https://github.com/plugify/online-betaal-platform'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/plugify/online-betaal-platform'
    spec.metadata['changelog_uri'] = 'https://github.com/plugify/online-betaal-platform'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #  `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  #end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files         = Dir['CODE_OF_CONDUCT.md', 'LICENSE.txt', 'README.md', 'lib/**/*.rb']
  spec.test_files    = Dir['test/**/*.rb']

  spec.add_dependency 'oj', '~> 3.7'
  spec.add_dependency 'rack', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'dotenv', '~> 2.7'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.5'
  spec.add_development_dependency 'rubocop', '~> 0.67'
  spec.add_development_dependency 'rubocop-performance', '~> 1.1'
end
