class ConnectedComponents

  attr_reader :graph, :vertexs, :connections, :visited, :num_faces

  def initialize(graph)
    @graph = graph
    @vertexs = graph.adjacency.keys #list of vertexs for a given graph
    @visited = Hash.new(false) #keep track of already visited nodes
    @connections = {} #connected components
    @num_faces = 0 #iterator, number of faces equals the number of connected
    #components for a given normal.
  end

  def dfs
    #Runs a depth first search to find all connected vertexes for a given normal
    #If a normal has two sets of connected components, this indicates, two faces.
    vertexs.each do |vertex|
      next if visited[vertex]
      queue = [vertex]
      @num_faces += 1
      until queue.empty?
        cur_vertex = queue.pop
        next if visited[cur_vertex]
        visited[cur_vertex] = true
        queue += vertex_children(cur_vertex)
        connections[cur_vertex] = num_faces
      end
    end
  end

  private

  def vertex_children(vertex) #return unvisited nodes of current vertex
    graph.adjacency[vertex].select { |el| visited[el] == false }
  end

end
