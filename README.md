# Kmeans::Crystal

There is a library for clustering data.
It's implemented by k-means algorithm.
With this library, You can monitor the training process of this model
and decide when to finish it if the result is convergence.

這是一個分群用的library。
他實作了k-means演算法。
透過這個library你可以監看整個model訓練的過程，
並且在結果收斂的時候結束訓練。


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kmeans-crystal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kmeans-crystal

## Usage

A simple example:

```ruby
require 'kmeans-crystal'
require 'json'

data = [
    {my_object: Object.new, features: [1, 3, 8 ]},
    {my_object: Object.new, features: [59, 51, 1 ]},
    {my_object: Object.new, features: [14, 13, -9 ]},
    {my_object: Object.new, features: [13, 3, -6 ]},
    {my_object: Object.new, features: [15, 325, 63 ]},
    {my_object: Object.new, features: [11, 32, 588 ]},
    {my_object: Object.new, features: [96, 77, -1000 ]},
    {my_object: Object.new, features: [5, 28, 8 ]}
]


# Find 3 clusters in data.
# 要分群的數量
k = 3

# Specify the field which you want to evaluate. Default named features.
# 要用來計算的欄位名稱，預設名稱為features
field_name = :features

mykmeans = KMeansCrystal::Model.new(k, data, field_name)
mykmeans.train do |i, clusters|
    puts clusters.to_json

    # Here you can moniter that data is convergence or not,
    # and specify conditions deciding how to finish the model's training.
    # 你可以在這邊觀察資料是否收斂
    # 並且決定何時應該結束模型的訓練
    break if i==10
end

puts mykmeans.result.to_json
puts mykmeans.predict( {my_object: 'new_object', features: [14, 13, 6 ]} )
```
