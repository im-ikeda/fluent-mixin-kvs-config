# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = "fluent-mixin-kvs-config"
  gem.version       = "0.0.1"
  gem.authors       = ["Takashi Ikeda"]
  gem.email         = ["im.ikeda@gmail.com"]
  gem.description   = %q{to add various placeholders for plugin configurations}
  gem.summary       = %q{Configuration syntax extension mixin for fluentd plugin}
  gem.homepage      = "https://github.com/imikeda/fluent-mixin-kvs-config"
  gem.license       = "APLv2"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "fluentd"
  gem.add_runtime_dependency "redis", ">= 3.2"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "test-unit"
end
