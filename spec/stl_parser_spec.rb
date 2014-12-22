require 'rspec'
require 'stl_parser'

describe STLParser do

  let(:parser) do
    STLParser.new('./data/cube.stl')
  end

  describe '#initialize' do
    it 'initializes with a stl file' do
      expect(parser.file).to eq('./data/cube.stl')
    end
  end

  describe '#readline' do
    it 'reads the first line on initialization' do
      expect(parser.send(:readline)).to eq('solid OpenSCAD_Model44')
    end
    it 'reads consecutive lines' do
      parser.send(:readline)
      expect(parser.send(:readline)).to eq('facet normal -1.000000 -0.000000 -0.000000')
    end
  end

  describe '#reopen' do
    it 'reopens a file' do
      parser.send(:readline)
      parser.send(:readline)
      expect(parser.send(:reopen)).to eq('solid OpenSCAD_Model44')
    end
  end

  describe '#parse' do
    it 'parses a file' do
      parser.parse
      expect(parser.graphs.keys.length).to eq(12)
    end
  end

  let (:graph) do
    parser.parse
    parser.graphs[parser.graphs.keys[1]]
  end

  describe '#numfaces' do
    it 'calculates the number of faces for a given graph' do
      parser.parse
      graph = parser.graphs[parser.graphs.keys[1]]
      expect(parser.send(:find_num_faces,graph)).to eq(1)
    end
  end

  describe '#calculate_results' do
    it 'calculates the correct number of faces' do
      parser.parse
      expect(parser.num_faces).to eq(13)
    end

    it 'calculates the correct number of vertexes' do
      parser.parse
      expect(parser.num_vertexs).to eq(22)
    end

    it 'returns an array with the correct number of faces and vertexs' do
      expect(parser.parse).to eq([13,22])
    end
  end

end
