#!/usr/bin/env ruby


##### DO NOT CHANGE BELOW THIS POINT ####
##### DO NOT CHANGE BELOW THIS POINT ####
##### DO NOT CHANGE BELOW THIS POINT ####
require 'securerandom'
require "bigdecimal"
require "fileutils"
require 'awesome_print'
require 'csv'

DELIMTER = "file"
CHANNEL = "ch_name"
TYPE = "ch_type"
OUTPUT_DIR = "./output"

def input_files
  filepaths = Dir["./input/*"]
  raise "Please ensure that the input files are in ./input directory" if filepaths.empty?
  filepaths
end

def sub_dir_from_filepath(filepath)
  filepath.scan(/\w+/)[1]
end

def decompose(filepath)
  raise "File #{filepath} Doens't exist" unless File.file?(filepath)

  channel = nil
  type = nil
  output_file = nil
  dir = "#{OUTPUT_DIR}/#{sub_dir_from_filepath(filepath)}"
  FileUtils::mkdir_p(dir) unless File.directory?(dir)

  CSV.foreach(filepath).with_index do |row, row_num|
    if row[0] == DELIMTER
      if output_file
        sensible_filename = [channel, type].map(&:downcase).join("_") + ".csv"
        File.rename(output_file.path, "#{dir}/#{sensible_filename}")
      end
      filename = SecureRandom.alphanumeric(10) + ".csv"
      output_file = CSV.open("#{dir}/#{filename}", "wb")
    end

    channel = row[1] if row[0] == CHANNEL
    type = row[1] if row[0] == TYPE

    output_file << row
  end

  if output_file
    sensible_filename = [channel, type].map(&:downcase).join("_") + ".csv"
    File.rename(output_file.path, "#{dir}/#{sensible_filename}")
  end
end

input_files.each { |filepath| decompose(filepath) }





