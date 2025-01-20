#!/usr/bin/env ruby

require "open3"
require "yaml"
require "optparse"
require "tsort"
require "colored"
require "active_support/core_ext/string"

class Hash
  include TSort
  alias tsort_each_node each_key

  def tsort_each_child(node, &block)
    fetch(node).to_s.scan(/<([\w\-]+)>/).flatten.each(&block)
  end
end

class TaskRunner
  def initialize(yaml_file, target_path = nil, params = {})
    @yaml_file = yaml_file
    @target_path = target_path
    @params = params
    @config = load_yaml
    @resolved_params = {}
    @placeholders = @params.keys.map { |p| "<#{p}>" }
  end

  def run
    if @target_path.nil?
      list_tasks(@config)
    else
      command = resolve_target
      abort "Error: Target '#{@target_path}' not found" unless command

      if command.is_a?(Hash)
        list_tasks(command, @target_path)
      else
        resolved_command = resolve_command(command)
        system(resolved_command)
      end
    end
  end

  private

  def highlight(str)
    str.gsub(/<([\w\-]+)>/) { |s| s.yellow }
  end

  def namespace(str)
    parts = str.split(".")
    title = parts.pop
    # .map(&:titleize)
    [parts.join(":").cyan, title.blue].join("\t")
  end

  def list_tasks(hash, parent_key = "")
    hash.each do |key, value|
      new_key = parent_key.empty? ? key.to_s : "#{parent_key}.#{key}"
      if value.is_a?(Hash)
        list_tasks(value, new_key)
      else
        next if new_key.empty? || value.nil? || value.empty?
        next unless @placeholders.any? { |p| value.include?(p) } || @placeholders.none?

        if true
          resolved_value = resolve_command(highlight(value))
          next unless new_key.split(".").any? { |k| k.start_with?("+") }
          puts [
                 namespace(new_key) + " #{value.scan(/<([\w\-]+)>/)
                   .map(&:first)
                   .uniq
                   .reject { |v| v.start_with?("_") }
                   .map { |v| "<#{v}>".yellow }.join(" ")}",

                 [new_key.strip, *@params.map { |k, v| "--#{k} \"#{v}\"" }].join(" "),
               ].join("\t")
          # puts [new_key.strip.blue, *value.scan(/<([\w\-]+)>/).map { |v| "<#{v.first}>" }].join(" ")
          # puts [
          #        new_key.strip.blue,
          #        *resolved_value.lines.map { |line| "  #{line.strip}" },
          #      ].join("\n") + "\n\n"
        else
          resolved_value = resolve_command(value)
          puts "#{new_key.strip}\n#{resolved_value.lines.map { |line| "  #{line.strip}" }.join("\n")}\0"
        end
      end
    end
  end

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

  def assert_output(command, output)
    exit 1 if output.empty?
  end

  def find_param_value(param_name, visited = Set.new)
    return @resolved_params[param_name] if @resolved_params.key?(param_name)
    return nil if visited.include?(param_name)

    visited.add(param_name)

    if @params.key?(param_name)
      @resolved_params[param_name] = @params[param_name]
      return @params[param_name]
    end

    if @target_path
      path_components = @target_path.split(".")
      while !path_components.empty?
        node = get_node_at_path(path_components)
        if node.is_a?(Hash) && node.key?(param_name)
          command = node[param_name]
          if command.is_a?(String)
            resolved_command = resolve_command(command, visited)
            value = `#{resolved_command}`.strip
            assert_output(resolved_command, value)
            @resolved_params[param_name] = value
            return value
          else
            @resolved_params[param_name] = command
            return command
          end
        end
        path_components.pop
      end
    end

    if @config.key?(param_name)
      command = @config[param_name]
      if command.is_a?(String)
        resolved_command = resolve_command(command, visited)
        value = `#{resolved_command}`.strip
        @resolved_params[param_name] = value
        return value
      else
        @resolved_params[param_name] = command
        return command
      end
    end

    nil
  end

  def resolve_command(command, visited = Set.new)
    command.to_s.gsub(/<([\w\-]+)>/) do |match|
      param_name = $1
      value = find_param_value(param_name, visited)
      if value.is_a?(Hash) and value["default"]
        value["default"]
      elsif !value.nil?
        value
      else
        match
      end
    end
  end
end

options = {}
parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [options] [file] [task]"

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

if ARGV.length < 1
  puts parser
  exit 1
end

yaml_file, target_path = *ARGV

TaskRunner.new(yaml_file, target_path, options).run
