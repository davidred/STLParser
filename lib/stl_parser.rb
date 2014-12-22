require 'byebug'
require_relative 'stl_graph'
require_relative 'stl_cc'

class STLParser

  attr_reader :file, :f, :graph, :graphs, :triangle, :normal, :corners, :num_faces, :num_vertexs

  HANDLERS = {
    facet_handler: true,
    vertex_handler: true,
    outer_handler: true,
    endloop_handler: true,
  }

  def initialize(file)
    @file = file
    @f = File.open(file)
    @corners = Hash.new(Array.new) #object that holds vertexs and corresponding normals

    @normal = nil #current facet normal
    @graph = nil #graph for current facet normal
    @graphs = {} #Hashmap of graphs for each facet normal

    @triangle = [] #current triangle stored as an array of vertexes
    @num_faces = 0
    @num_vertices = 0
    @num_corners = 0
  end

  def print_file_contents
    #prints entire stl file to console (for testing)
    while true do
      line = @f.gets
      break if line.nil?
      puts line.chomp
    end
    @f.close
    @f = File.open(file)
  end

  def parse(end_of_file = false)
    #parse file and calculate results
    until end_of_file
      end_of_file = parse_handler(@f.gets.chomp.strip)
    end

    calculate_results
    return [@num_faces, @num_corners, @num_vertices]
  end

  private

  def calculate_results
    graphs.each do |key, graph|
      @num_faces += find_num_faces(graph)
    end
    @num_corners = find_num_corners
  end

  def find_num_faces(graph)
    #each normal graph has a number of faces
    #equivalent to groups of connected components
    cc = ConnectedComponents.new(graph)
    cc.dfs #depth first search to find number of faces
    cc.num_faces #return number of faces for the given normal
  end

  def find_num_corners
    #a vertex is defined by a point that is shared by at least 3 faces
    count = 0
    @corners.each do |vertex, normals_array|
      count += 1 if normals_array.length >= 3
    end
    count
  end

  def parse_handler(line)
    #determine which callback to use based on first word
    return true if line.split()[0] == "endsolid"
    handler = (line.split()[0] + "_handler").to_sym #generate handler method name
    send(handler, line) if HANDLERS.include?(handler) #call appropriate callback
    false #return false, indicating the end of the file has not been reached
  end

  def readline #reads one line at a time
    line = @f.gets
    line.nil? ? reopen : line.chomp.strip
  end

  def reopen #closes and reopens the file to start it from the beginning
    @f.close
    @f = File.open(file)
    readline
  end

  def vertex_handler(line) #takes a vertex line and extracts
    line = line.split('vertex ')[1] #extracts xyz coordinates of vertex
    vertex = parse_vertex(line)
    triangle << vertex #stores each vertex in the current triangle instance variable
    #add distinct normals to each vertex
    corners[vertex] += [normal] unless corners[vertex].include?(normal)
    @num_vertices += 1
  end

  def outer_handler(line)
    @triangle = [] #reset triangle when end of triangle is reached
  end

  def facet_handler(line)
    #if current normal already exists, continue using the same graph object,
    #otherwise, create new graph object
    cur_normal = parse_vertex(line.split('normal ')[1])
    if @normal.nil?
      @graph = STLGraph.new
      @graphs[cur_normal] = graph
      @normal = cur_normal
    elsif @normal != cur_normal
      @normal = cur_normal
      @graph = STLGraph.new
      @graphs[cur_normal] = graph
    else
      @graph = graphs[cur_normal]
    end
  end

  def endloop_handler(line)
    #add appropriate adjacencies to the current graph
    @graph.add(triangle[0], triangle[1])
    @graph.add(triangle[0], triangle[2])
    @graph.add(triangle[1], triangle[0])
    @graph.add(triangle[1], triangle[2])
    @graph.add(triangle[2], triangle[0])
    @graph.add(triangle[2], triangle[1])
    triangle = []
  end

  def parse_vertex(line)
    #return a slightly more compressed vertex line. Ignore "-0.0".
    vertex = line.split().map(&:to_f).map{|el| el == -0.0 ?  0.0 : el }
    vertex.join(" ")
  end


end
