# frozen_string_literal: true

require 'rubygems'
require 'gems'
require 'csv'

gems_info_arr = []
ARGV.each do |gemfile|
  puts "Processing #{gemfile}"
  IO.foreach(gemfile) do |line|
    next if line !~ /^\s*gem /

    gem = line.match(/(?<=(['"]))(.*?)(?=\1)/)[0]

    gem_info = Gems.info gem
    gem_name = gem
    gem_desc = gem_info['info'].delete("\n").strip.gsub(/\s+/, ' ')
    project_uri = gem_info['project_uri']
    homepage_uri = gem_info['homepage_uri']
    documentation_uri = gem_info['documentation_uri']
    source_code_uri = gem_info['metadata']['source_code_uri']
    development_dependencies = gem_info['dependencies']['development'].flat_map { |v| v['name'] }.join(', ')
    runtime_dependencies = gem_info['dependencies']['runtime'].flat_map { |v| v['name'] }.join(', ')

    gems_info_arr << [gem_name, gem_desc, project_uri, homepage_uri, documentation_uri,
                      source_code_uri, development_dependencies, runtime_dependencies]
  end
end

puts 'Writing to results/gems-info.csv'
CSV.open('results/gems-info.csv', 'w') do |csv|
  csv << ['Gem', 'Summary', 'Project URI', 'Homepage URI', 'Documentation URI',
          'Source Code URI', 'Development Dependencies', 'Runtime Dependencies']
  gems_info_arr.each do |line|
    csv << line
  end
end

puts 'Done ...'
