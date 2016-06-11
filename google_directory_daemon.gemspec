# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
app = File.expand_path('../app', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(app)


Gem::Specification.new do |spec|
  spec.name          = "google_directory_daemon"
  spec.version       = "1.0.0"
  spec.authors       = ["Alexandre Narbonne", "Mathieu Goulin"]

  spec.summary       = "RabbitMQ bot gateway to GoogleDirectoryApi"
  spec.license       = "MIT"
end
