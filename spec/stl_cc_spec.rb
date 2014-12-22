require 'rspec'
require 'stl_graph'
require 'stl_cc'

describe ConnectedComponents do
  describe 'Simple case' do
    let(:graph) do
      STLGraph.new
    end

    let(:cc) do
      ConnectedComponents.new(graph)
    end

    before(:each) do
      graph.add('-5 -5 0', '-5 -5 10')
      graph.add('-5 -5 0', '-5 5 0')
      graph.add('-5 5 0', '-5 -5 10')
      graph.add('-5 5 0', '-5 5 10')
      cc.dfs
    end

    describe '#initialize' do
      it 'initializes with an empty object' do
        empty_graph = STLGraph.new()
        expect(empty_graph.adjacency).to eq({})
      end
    end

    describe '#add' do
      it 'adds new vertexes' do
        expect(graph.adjacency['-5 -5 0']).to eq(['-5 -5 10', '-5 5 0'])
      end
    end

    describe '#dfs' do
      it 'returns all connected components' do
        expect(cc.connections).to eq({"-5 -5 0"=>1, "-5 5 0"=>1, "-5 5 10"=>1, "-5 -5 10"=>1})
      end

      it 'returns 1 for a normal with one face' do
        expect(cc.num_faces).to eq(1)
      end
    end
  end

  describe 'Case with multiple faces for a given normal' do
    let(:multiple_graph) do
      STLGraph.new
    end

    let(:multiple_cc) do
      ConnectedComponents.new(multiple_graph)
    end

    before(:each) do
      multiple_graph.add('5 -5 10', '-5 -5 0')
      multiple_graph.add('5 -5 10', '5 5 0')
      multiple_graph.add('-5 -5 0', '5 -5 10')
      multiple_graph.add('-5 -5 0', '5 5 0')
      multiple_graph.add('5 5 0', '-5 -5 0')
      multiple_graph.add('5 5 0', '5 -5 10')

      multiple_graph.add('5 5 10', '5 -5 10')
      multiple_graph.add('5 5 10', '5 5 0')
      multiple_graph.add('5 -5 10', '5 5 10')
      multiple_graph.add('5 -5 10', '5 5 10')
      multiple_graph.add('5 5 0', '5 -5 10')
      multiple_graph.add('5 5 0', '5 5 10')

      multiple_graph.add('-1.801938 0.867767 0', '-1.801938 0.867767 10')
      multiple_graph.add('-1.801938 0.867767 0', '-1.801938 -0.867767 0')
      multiple_graph.add('-1.801938 -0.867767 0', '-1.801938 0.867767 0')
      multiple_graph.add('-1.801938 -0.867767 0', '-1.801938 0.867767 10')
      multiple_graph.add('-1.801938 0.867767 10', '-1.801938 0.867767 0')
      multiple_graph.add('-1.801938 0.867767 10', '-1.801938 -0.867767 0')

      multiple_graph.add('-1.801938 -0.867767 0', '-1.801938 0.867767 0')
      multiple_graph.add('-1.801938 -0.867767 0', '-1.801938 -0.867767 10')
      multiple_graph.add('-1.801938 0.867767 0', '-1.801938 -0.867767 10')
      multiple_graph.add('-1.801938 0.867767 0', '-1.801938 -0.867767 0')
      multiple_graph.add('-1.801938 -0.867767 10', '-1.801938 0.867767 0')
      multiple_graph.add('-1.801938 -0.867767 10', '-1.801938 -0.867767 0')

      multiple_cc.dfs
    end

    describe '#dfs' do
      it 'returns 2 for a normal with two faces' do
        expect(multiple_cc.num_faces).to eq(2)
      end
    end

  end
end
