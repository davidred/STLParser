class STLGraph

  attr_reader :adjacency

  def initialize
    @adjacency = Hash.new { Array.new } #key is vertex, value is array of normals
  end

  def add(vertex, normal)
    adjacency[vertex] += [normal] unless adjacency[vertex].include?(normal)
  end

  def to_s
    @adjacency.each do |vertex, normals_array|
      p "vertex #{vertex} has links along the normals #{normals_array}"
    end
  end

  def num_vertexs
    @adjacency.keys.count
  end

  def num_vertices
    count = 0
    @adjacency.each do |vertex, normals_array|
      count += 1 if normals_array.length >= 3
    end
    count
  end

  def num_faces
    count = 0
    unique_normals = Hash.new(false)
    @adjacency.each do |vertex, normals_array|
      unique_normals[normals_array] = true
    end
    unique_normals.keys.count
  end

end
