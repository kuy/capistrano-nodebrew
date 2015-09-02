namespace :nodebrew do
  task :validate do
    on release_roles(fetch(:nodebrew_roles)) do
      nodebrew_node = fetch(:nodebrew_node)
      if nodebrew_node.nil?
        error "nodebrew: nodebrew_node is not set"
        exit 1
      end

      unless test "[ -d #{fetch(:nodebrew_node_dir)} ]"
        error "nodebrew: #{nodebrew_node} is not installed or not found in #{fetch(:nodebrew_node_dir)}"
        exit 1
      end
    end
  end

  task :map_bins do
    SSHKit.config.default_env.merge!({ path: "#{fetch(:nodebrew_path)}/current/bin:$PATH" })
    nodebrew_prefix = fetch(:nodebrew_prefix, proc { "#{fetch(:nodebrew_path)}/current/bin/nodebrew exec #{fetch(:nodebrew_node)}" })
    SSHKit.config.command_map[:nodebrew] = "#{fetch(:nodebrew_path)}/current/bin/nodebrew"

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

    set :nodebrew_roles, fetch(:nodebrew_roles, :all)

    set :nodebrew_node_dir, -> { "#{fetch(:nodebrew_path)}/versions/#{fetch(:nodebrew_node)}" }
    set :nodebrew_map_bins, %w{npm node iojs}
  end
end
