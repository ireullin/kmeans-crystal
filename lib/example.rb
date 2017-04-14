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

# Optional parameters 選擇性參數
#
# vector_name: Specify the field which you want to evaluate. Default named features.
# vector_name: 要用來計算的欄位名稱, 預設名稱為features
#
# distance: How to measure distances? euclidean or manhattan. Default is euclidean.
# distance: 如何計算點之間的距離, 可選擇euclidean或manhattan. 預設是 euclidean.
#
# init_centroids: How to initialize centroids? random or kmean++. Default is kmeans++.
# init_centroids: 如何決定起始的質心, 可選擇random或是kmean++. 預設是 kmeans++.
mykmeans = KMeansCrystal::Model.new(k, data, vector_name: :features, distance: 'euclidean', init_centroids: 'kmeans++')
mykmeans.train do |i, clusters|
    puts JSON.pretty_generate(clusters)

    # Here you can moniter that data is convergence or not,
    # and specify conditions deciding how to finish the model's training.
    # 你可以在這邊觀察資料是否收斂
    # 並且決定何時應該結束模型的訓練
    break if i==10
end

puts JSON.pretty_generate(mykmeans.result)

mykmeans.rename_clusters do |map|
    map['cluster0'] = 'mine'
    map['cluster1'] = 'yours'
    map['cluster2'] = 'his'
end

puts JSON.pretty_generate(mykmeans.result)

puts mykmeans.predict( {my_object: 'new_object', features: [14, 13, 6 ]} )
