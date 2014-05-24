require 'open3'

class Daemon

  SUCCESS_SYNC_STRING = "~~~~COMMAND SUCCESFULL~~~~\n"
  FAILED_SYNC_STRING = "~~~~COMMAND FAILED~~~~\n"

  @@daemons = Hash.new

  def self.daemonized?(identity)
    daemon_for(identity) != nil
  end

  def self.daemon_for(identity)
    @@daemons[identity]
  end

  def initialize(identifier, command, user)
    if @@daemons[identifier]
      return @@daemons[identifier]
    else
      initialize_daemon(user,command)
      @identifier = identifier
      @@daemons[identifier] = self
    end
  end

  def execute_command(command)
    @stdin.puts command
  end

  def sync
    @stdout.each_line do |line|
      Puppet.debug "#{line}" 
      break if line == SUCCESS_SYNC_STRING
      fail "command in deamon failed." if line == FAILED_SYNC_STRING
    end
  end

  private

    def initialize_daemon(user, command)
      if user
        @stdin, @stdout, @stderr = Open3.popen3("su - #{user}")
        execute_command(command)
      else
        @stdin, @stdout, @stderr = Open3.popen3(command)
      end
    end

end
