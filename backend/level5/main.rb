# frozen_string_literal: true

require_relative '../models/data_processor'
input_file = File.join(__dir__, 'data/input.json')
output_file = File.join(__dir__, 'data/output.json')

DataProcessor.new(input_file, output_file).process
