# frozen_string_literal: true

require 'spec_helper'
require 'json'

RSpec.describe 'Main' do
  let(:input_file) { File.join(__dir__, '../level5/data/input.json') }
  let(:output_file) { File.join(__dir__, '../level5/data/expected_output.json') }

  before do
    file = File.read(input_file)
    @data_hash = JSON.parse(file)
  end

  it 'should generate the expected output' do
    load 'level5/main.rb'

    expected_output = File.read(output_file)
    output = File.read(File.join(__dir__, '../level5/data/output.json'))

    expect(JSON.parse(output)).to eq(JSON.parse(expected_output))
  end
end
