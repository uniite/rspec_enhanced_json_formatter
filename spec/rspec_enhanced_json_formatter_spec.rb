RSpec.describe RSpecEnhancedJSONFormatter do
  let(:output) { run_example_specs_with_formatter(described_class.to_s) }
  let(:events) { parse_json_lines(output) }

  it 'generates valid JSON objects' do
    expect(events.map(&:class).uniq).to eq([Hash])
  end

  it 'indicates the type of each event' do
    expect(events[0..-2].map { |e| e['type'] }.uniq).to eq(['test'])
  end

  it 'indicates the id of each test' do
    expect(events[0..-2].map { |e| e['id'] }.uniq).to eq(%w[
      ./spec/fixtures/example_spec_.rb[1:1]
      ./spec/fixtures/example_spec_.rb[1:2]
      ./spec/fixtures/example_spec_.rb[1:3]
      ./spec/fixtures/example_spec_.rb[1:4]
      ./spec/fixtures/example_spec_.rb[1:5]
      ./spec/fixtures/example_spec_.rb[1:6]
    ])
  end

  it 'indicates the duration of each test' do
    expect(events[0..-2].map { |e| e['duration'].class }.uniq).to eq([Float])
  end

  it 'includes the status of each test' do
    expect(events[0..-2].map { |e| e['status'] }).to eq(%w[passed failed failed failed failed pending])
  end

  it 'indicates the name of each test' do
    expect(events[0..-2].map { |e| e['name'] }).to eq([
      'Example passes tests',
      'Example fails on bad expectations',
      'Example fails on exceptions',
      'Example fails aggregate tests',
      'Example has pending tests',
      'Example has pending tests with no reason',
    ])
  end

  it 'ends with a summary' do
    expect(events.last).to include({
      'type' => 'summary',
      'total' => 6,
      'failed' => 4,
      'pending' => 1
    })
  end
end
