RSpec.describe 'Example' do
  it 'passes tests' do
    expect('a').to eq('a')
  end

  it 'fails on bad expectations' do
    expect('a').to eq('b')
  end

  it 'fails on exceptions' do
    raise StandardError, 'no good'
  end

  it 'fails aggregate tests' do
    aggregate_failures do
      expect('a').to eq('b')
      expect('a').to eq('c')
    end
  end

  it 'has pending tests' do
    pending 'just because'
  end

  xit 'has pending tests with no reason' do
    expect('foo').to eq('bar')
  end
end
