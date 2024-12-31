# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "to_llm"
  spec.version       = "0.1.2"
  spec.authors       = ["José Carlos Maciel"]
  spec.email         = ["jcmacielp@gmail.com"]
  spec.summary       = %q{Extracts code from a Rails project to text files for LLM usage.}
  spec.description   = %q{A simple gem that provides a Rails command or Rake tasks to export .rb, .erb, .js, and .yml files into .txt for LLM ingestion.}
  spec.homepage      = "https://github.com/jcmaciel/to_llm"
  spec.license       = "MIT"
  spec.metadata      = {
    "source_code_uri" => "https://github.com/jcmaciel/to_llm"
  }

  spec.files         = Dir["lib/**/*", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", ">= 5.0" 
end
