class STLGraph

  attr_reader :adjacency

  def initialize
    #object stores points as the key, and array of adjacent points as the value
    @adjacency = Hash.new { Array.new }
  end

  def add(vertex_from, vertex_to)
    adjacency[vertex_from] += [vertex_to]
  end

  def to_s
    #prints graph object for testing purposes
    @adjacency.each do |vertex, connections|
      puts "vertex #{vertex} links to #{connections}"
    end
  end

  def num_vertexs
    @adjacency.keys.count
  end

end
