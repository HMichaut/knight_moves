require './lib/knight_moves'

describe '#knight_moves_aux' do
  it 'returns the sequence for a square one jump away.' do
    expect(knight_moves_aux([0, 0], [1, 2])).to eql([[0, 0], [1, 2]])
  end
  it 'returns the sequence for a square two jumps away.' do
    expect(knight_moves_aux([0, 0], [3, 3])).to eql([[0, 0], [1, 2], [3, 3]])
  end
  it 'returns the sequence for a square two jumps away.' do
    expect(knight_moves_aux([3, 3], [0, 0])).to eql([[3, 3], [2, 1], [0, 0]])
  end
  it 'returns the sequence for a square three jumps away.' do
    expect(knight_moves_aux([3, 3], [4, 3])).to eql([[3, 3], [4, 5], [2, 4], [4, 3]])
  end
end
