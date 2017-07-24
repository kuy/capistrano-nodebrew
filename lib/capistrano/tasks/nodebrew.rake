namespace :nodebrew do
  task :validate do
    on release_roles(fetch(:nodebrew_roles)) do
      nodebrew_bin = fetch(:nodebrew_bin)
      unless test "[ -e #{nodebrew_bin} ]"
        error "nodebrew: command not found"
        exit 1
      end

      nodebrew_node = fetch(:nodebrew_node)
      if nodebrew_node.nil?
        error "nodebrew: 'nodebrew_node' is not set"
        exit 1
      end

      versions = capture("#{nodebrew_bin} ls").lines.map{|l| l.strip}.reject{|l| l.empty?}
      unless versions.include? nodebrew_node
        error "nodebrew: #{nodebrew_node} is not installed"
        exit 1
      end
    end
  end

  task :map_bins do
    SSHKit.config.default_env.merge!({ nodebrew_root: fetch(:nodebrew_path) })
    SSHKit.config.default_env.merge!({ path: "#{fetch(:nodebrew_path)}/current/bin:$PATH" })
    nodebrew_prefix = fetch(:nodebrew_prefix, proc { "#{fetch(:nodebrew_bin)} exec #{fetch(:nodebrew_node)}" })
    SSHKit.config.command_map[:nodebrew] = fetch(:nodebrew_bin)

    fetch(:nodebrew_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(nodebrew_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, 'nodebrew:validate'
  after stage, 'nodebrew:map_bins'
end

namespace :load do
  task :defaults do
    set :nodebrew_path, -> {
      nodebrew_path = fetch(:nodebrew_custom_path)
      nodebrew_path ||= if fetch(:nodebrew_type, :user) == :system
        "/usr/local/nodebrew"
      else
        "~/.nodebrew"
      end
    }

    set :nodebrew_bin, -> { "#{fetch(:nodebrew_path)}/current/bin/nodebrew" }
    set :nodebrew_roles, fetch(:nodebrew_roles, :all)
    set :nodebrew_map_bins, %w{npm node iojs}
  end
end
