# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "kmeans-crystal"
  spec.version       = '1.1.0'
  spec.authors       = ["ireullin"]
  spec.email         = ["ireullin@gmail.com"]
  spec.date          = '2017-04-14'
  spec.homepage      = 'https://github.com/ireullin/kmeans-crystal'
  spec.summary       = %Q{With this library, you can monitor the model’s training process and end the training if the result is converged.}
  spec.description   = %Q{The library for data clustering is implemented by k-means algorithm.With the library, you can monitor the model’s training processand end the training if the result is converged.
這是一個分群用的library。他實作了k-means演算法。透過這個library你可以監看整個model訓練的過程，並且在結果收斂的時候結束訓練。}
  spec.license       = "MIT"
  spec.files         = ['lib/kmeans-crystal.rb']
end
