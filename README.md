# Kmeans::Crystal

A k-means's implementation which allows you to monitor the process, being convergence or not.

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

Simple example:

```ruby
require 'kmeans-crystal'
require 'json'

data = [
    {my_object: Object.new, features: [1, 3 ]},
    {my_object: Object.new, features: [59, 51 ]},
    {my_object: Object.new, features: [14, 13 ]},
    {my_object: Object.new, features: [13, 3 ]},
    {my_object: Object.new, features: [15, 325 ]},
    {my_object: Object.new, features: [11, 32 ]},
    {my_object: Object.new, features: [96, 77 ]},
    {my_object: Object.new, features: [5, 28 ]}
]


# Find 3 clusters in data
k = 3

# Specify field which you want to evaluate. Default named features
field_name = :features

mykmeans = KMeansCrystal::Model.new(3, data, field_name)
mykmeans.train do |i, clusters|
    puts clusters.to_json

    # You can moniter whether convergence
    # and specify conditions deciding how to finish training
    break if i==10
end

puts mykmeans.result.to_json
puts mykmeans.predict( {my_object: 'new_object', features: [14, 13 ]} )
```
