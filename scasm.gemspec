# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scasm/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rich Lane"]
  gem.email         = ["rlane@club.cc.cmu.edu"]
  gem.description   = %q{A Ruby DSL for DCPU-16 assembly code}
  gem.summary       = %q{A Ruby DSL for DCPU-16 assembly code}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scasm"
  gem.require_paths = ["lib"]
  gem.version       = Scasm::VERSION
end
