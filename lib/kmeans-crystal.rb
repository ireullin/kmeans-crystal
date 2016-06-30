module KMeansCrystal
class Cluster
    attr_reader :centroid
    attr_reader :entries
    attr_accessor :name

    def initialize(name, centroid, vector_name)
        @name = name
        @centroid = centroid
        @entries = Array.new
        @vector_name = vector_name
    end

    def output
        return { name: @name, centroid: @centroid, entries: @entries }
    end

    def distance(entry)
        sum = 0.0
        @centroid.size.times{|i| sum += (@centroid[i]-entry[@vector_name][i])**2}
        return Math.sqrt(sum)
    end

    def update_centroid
        new_centroid = Array.new(entries[0][@vector_name].size, 0.0)
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
    def initialize(cluster_num, entries, vector_name = :features)
        raise 'too less cluster_num to evaluate k-means' if entries.size < cluster_num
        @cluster_num = cluster_num
        @entries = entries
        @vector_name = vector_name

        init_centroids = @entries.sample(@cluster_num).map{|x| x[@vector_name]}
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
            clusters << Cluster.new("cluster#{i}", centroid, @vector_name)
        end
        return clusters
    end

    def new_clusters_from_old(clusters)
        arr = Array.new
        clusters.each do |cluster|
            arr << Cluster.new(cluster.name, cluster.update_centroid, @vector_name)
        end
        return arr
    end
end
end
