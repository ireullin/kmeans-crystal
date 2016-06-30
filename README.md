# Kmeans::Crystal

The library for data clustering is implemented by k-means algorithm.
With the library, you can monitor the model’s training process
and end the training if the result is converged.

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


# Decide k of group of clustering data
# 要分群的數量
k = 3

# The name of the column for evaluation is “features” by default.
# 要用來計算的欄位名稱，預設名稱為features
field_name = :features

mykmeans = KMeansCrystal::Model.new(k, data, field_name)
mykmeans.train do |i, clusters|
    puts clusters.to_json

    # You may monitor if the data is converged or not here.
    # You can decide when to end the training of the model.
    # 你可以在這邊觀察資料是否收斂
    # 並且決定何時應該結束模型的訓練
    break if i==10
end

puts mykmeans.result.to_json
puts mykmeans.predict( {my_object: 'new_object', features: [14, 13, 6 ]} )
```
