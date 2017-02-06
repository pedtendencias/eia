# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eia/version'

Gem::Specification.new do |spec|
  spec.name          = "eia"
  spec.version       = Eia::VERSION
  spec.authors       = ["rCamposCruz"]
  spec.email         = ["rcampos@tendencias.com.br"]

  spec.summary       = %q{A gem tham aims to facilitate interactions with Brazil's IBGE WebService.}
  spec.description   = %q{This gem is supposed to supply a simple and intuitive interface between IBGE's SIDRA API, standardizing the output objects as a standard class. Also makes seamlessly to interact with the API, transforming the inputs for the webservice in intuitive function entries. Eia stands for Easy IBGE Acess and was developed in a partnership with Tendencias - Consultoria Econômica.}
  spec.homepage      = "https://github.com/rCamposCruz/eia"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "net", "~> 0.3"
  spec.add_development_dependency "json", "~> 2.0"
end
