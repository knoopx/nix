#!/usr/bin/env ruby

require "open3"
require "yaml"
require "optparse"
require "tsort"

class Hash
  include TSort
  alias tsort_each_node each_key

  def tsort_each_child(node, &block)
    fetch(node).to_s.scan(/<(\w+)>/).flatten.each(&block)
  end
end

class TaskRunner
  def initialize(yaml_file, target_path, params = {})
    @yaml_file = yaml_file
    @target_path = target_path
    @params = params
    @config = load_yaml
    @resolved_params = {}
  end

  def run
    command = resolve_target
    abort "Error: Target '#{@target_path}' not found" unless command

    if group?(command)
      list_tasks(command)
    else
      resolved_command = resolve_command(command)
      # puts "> #{resolved_command}"
      system(resolved_command)
    end
  end

  private

  def load_yaml
    YAML.load_file(@yaml_file)
  rescue Errno::ENOENT
    abort "Error: Could not find YAML file: #{@yaml_file}"
  rescue Psych::SyntaxError
    abort "Error: Invalid YAML syntax in file: #{@yaml_file}"
  end

  def get_node_at_path(path)
    return @config if path.empty?

    current = @config
    path.each do |component|
      return nil unless current.is_a?(Hash) && current.key?(component)
      current = current[component]
    end
    current
  end

  def resolve_target
    path_components = @target_path.split(".")
    get_node_at_path(path_components)
  end

  def group?(node)
    node.is_a?(Hash) && node.keys.all? { |key| key.start_with?("task_") }
  end

  def list_tasks(group)
    puts "Tasks in group '#{@target_path}':"
    group.each do |task_name, task_command|
      puts "- #{task_name}: #{task_command}"
    end
  end

  def find_param_value(param_name, visited = Set.new)
    command.to_s.gsub(/<(\w+)>/) do |match|
      param_name = $1
      value = find_param_value(param_name, visited)
      value || match
    end
  end

  def resolve_command(command, visited = Set.new)
    command.to_s.gsub(/<(\w+)>/) do |match|
      param_name = $1
      value = find_param_value(param_name, visited)
      value || match
    end
  end
end

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] yaml_file target_path"

  opts.on("-h", "--help", "Display this help") do
    puts opts
    exit
  end
end

ARGV.each_with_index do |arg, index|
  if arg.start_with?("--")
    param_name = arg[2..-1]
    if index + 1 < ARGV.length && !ARGV[index + 1].start_with?("--")
      options[param_name] = ARGV[index + 1]
    end
  end
end

ARGV.reject! { |arg| arg.start_with?("--") || options.values.include?(arg) }

if ARGV.length != 2
  puts parser
  exit 1
end

yaml_file, target_path = ARGV

runner = TaskRunner.new(yaml_file, target_path, options)
runner.run
