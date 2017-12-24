require 'shell-helper'
require 'logging-helper'
require 'deluge'

module Deluge
  class Daemon
    class << self
      @@instance = nil
      def instance
        return @@instance unless @@instance.nil?
        @@instance = new
      end

      def start
        instance.start
      end

      def stop
        instance.stop
      end
    end

    include ShellHelper::Shell
	  include LoggingHelper::LogToTerminal

    attr_reader :deluge_dir_path, :auth_file_path, :log_file_path
    attr_reader :config_file_path, :pid_file_path

    def initialize
      @deluge_dir_path = "#{$WORKSPACE_SETTINGS[:paths][:project][:home]}/deluge"
      @auth_file_path = "#{deluge_dir_path}/auth"
      @log_file_path = "#{deluge_dir_path}/deluged.log"
      @config_file_path = "#{deluge_dir_path}/core.conf"
      @pid_file_path = "#{deluge_dir_path}/deluged.pid"
    end

    def read_auth_file(line_number=0)
      deluge_auth_content = File.read(auth_file_path)
      user_name, password, auth_level = deluge_auth_content.split("\n")[line_number].split(':')
      {
        user_name: user_name,
        password: password,
        auth_level: auth_level
      }
    end

    def start
      log_level = ENV['LOG_LEVEL'].upcase
      shell_command!("deluged -c #{deluge_dir_path} -P #{pid_file_path} -L #{log_level} -l #{log_file_path}")
    end

    def stop
      pid = File.read(pid_file_path).split(';')[0]
      shell_command!("kill -9 #{pid}")
    end

    def rpc_client
      return @rpc_client unless @rpc_client.nil?

      auth_info = read_auth_file
      @rpc_client = Deluge::Rpc::Client.new(
        host: 'localhost',
        port: 58846,
        login: auth_info[:user_name],
        password: auth_info[:password]
      )
      @rpc_client.connect

      @rpc_client
    end

  end
end
