# require 'kmeans-crystal'
require './kmeans-crystal.rb'
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
# 要用來計算的欄位名稱,預設名稱為features
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

mykmeans.rename_clusters do |map|
    map['cluster0'] = 'mine'
    map['cluster1'] = 'yours'
    map['cluster2'] = 'his'
end

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
