module KMeansCrystal

module Measure
    # 歐式距離
    class Euclidean
        def self.distance(a,b)
            sum = 0.0
            a.size.times{|i| sum += (a[i] -b[i])**2 }
            return Math.sqrt(sum)
        end
    end

    # 曼哈頓距離
    class Manhattan
        def self.distance(a,b)
            sum = 0.0
            a.size.times{|i| sum += (a[i] -b[i]).abs }
            return Math.sqrt(sum)
        end
    end
end


class Cluster
    attr_reader :centroid
    attr_reader :entries
    attr_accessor :name

    def initialize(name, centroid, vector_name, measure)
        @name = name
        @centroid = centroid
        @entries = Array.new
        @vector_name = vector_name
        @measure = measure
    end

    def output
        output_entries = @entries.map{|e| e[:distance] = distance(e); e }
        return { name: @name, centroid: @centroid, entries: output_entries }
    end

    def distance(entry)
        return @measure.distance(@centroid, entry[@vector_name])
    end

    def update_centroid
        new_centroid = Array.new(@centroid.size, 0.0)
        return new_centroid if entries.size==0

        entries.each do |entry|
            entry[@vector_name].size.times do |i|
                new_centroid[i] += entry[@vector_name][i]
            end
        end
        new_centroid.map!{|e| e/entries.size }
        return new_centroid
    end
end


class Model
    def initialize(cluster_num, entries, **params)
        raise 'too less cluster_num to evaluate k-means' if entries.size < cluster_num

        @cluster_num = cluster_num
        @entries = entries

        @vector_name = case params[:vector_name]
        when nil
            :features
        else
            params[:vector_name]
        end

        @measure = case params[:distance]
        when 'manhattan'
            Measure::Manhattan
        when 'euclidean',nil
            Measure::Euclidean
        else
            raise 'incorrect value for distance'
        end

        init_centroids = case params[:init_centroids]
        when 'random'
            @entries.sample(@cluster_num).map{|x| x[@vector_name]}
        when 'kmeans++',nil
            kmeans_pp(@entries, @cluster_num)
        else
            raise 'incorrect value for init_centroids'
        end

        p @vector_name
        p @measure
        p init_centroids

        @clusters = new_clusters(init_centroids)
    end

    def train
        i = 0
        while true do
            @entries.each do |entry|
                min_cluster = get_min(@clusters, entry)
                min_cluster.entries << entry
            end

            yield(i+=1, @clusters.map{|x| x.output} )

            @clusters = new_clusters_from_old(@clusters)
        end
    end

    def result
        return @clusters.map{|x| x.output}
    end

    def predict(entry)
        raise 'has not been trained' if @clusters.nil?
        predicted_cluster = get_min(@clusters, entry)
        return predicted_cluster.name
    end

    def rename_clusters
        named_map = Hash.new
        @clusters.each{|x| named_map[x.name] = x.name }
        yield(named_map)
        @clusters.each do |cluster|
            cluster.name = named_map[cluster.name]
        end
    end

    private
    def get_min(centroids, entry)
        min_cluster = centroids[0]
        last_distance = centroids[0].distance(entry)
        1.upto(centroids.size-1) do |i|
            current_distance = centroids[i].distance(entry)
            next if current_distance > last_distance
            min_cluster = centroids[i]
            last_distance = current_distance
        end
        return min_cluster
    end

    def new_clusters(centroids)
        clusters = Array.new
        centroids.each_with_index do |centroid, i|
            clusters << Cluster.new("cluster#{i}", centroid, @vector_name, @measure)
        end
        return clusters
    end

    def new_clusters_from_old(clusters)
        arr = Array.new
        clusters.each do |cluster|
            arr << Cluster.new(cluster.name, cluster.update_centroid, @vector_name, @measure)
        end
        return arr
    end

    def kmeans_pp(entries, cluster_num)
        features = entries.map{|x| x[@vector_name]}
        dimension = features.first.size
        init_val = Array.new(dimension){[0.0,0.0]}
        dimension.times do |i|
            init_val[i][0] = features.map{|f| f[i]}.to_a.min
            init_val[i][1] = features.map{|f| f[i]}.to_a.max
        end

        init_centroids = entries.sample(cluster_num).map{|x| x[@vector_name]}
        combination = 2**dimension
        combination.times do |i|
            break if i >= init_centroids.size
            offset = i.to_s(2).rjust(dimension,"0")
            dimension.times do |d|
                max_or_min = offset[d].to_i
                init_centroids[i][d] = init_val[d][max_or_min]
            end

        end
        return init_centroids
    end
end
end
