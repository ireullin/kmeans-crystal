# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "kmeans-crystal"
  spec.version       = 0.1
  spec.authors       = ["ireullin"]
  spec.email         = ["ireullin@gmail.com"]
  spec.date          = '2016-06-29'
  spec.homepage      = 'https://github.com/ireullin/kmeans-crystal'
  spec.summary       = %q{A gem which implements k-means clustering algorithm.}
  spec.description   = %q{A k-means's implementation which allows you to monitor the process, being convergence or not.}
  spec.license       = "MIT"
  spec.files         = ['lib/kmeans-crystal.rb']
end
