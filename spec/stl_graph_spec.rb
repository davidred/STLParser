require 'rspec'
require 'stl_graph'

describe STLGraph do

  let(:graph) do
    STLGraph.new
  end

  describe '#initialize' do
    it 'initializes with an empty object' do
      empty_graph = STLGraph.new()
      expect(empty_graph.adjacency).to eq({})
    end

  end

  describe '#add' do
    it 'adds new vertexes' do
      graph.add('-5 -5 0', '-5 5 0')
      graph.add('-5 -5 0', '-1 0 0')
      expect(graph.adjacency['-5 -5 0']).to eq(['-5 5 0', '-1 0 0'])
    end
  end

end
