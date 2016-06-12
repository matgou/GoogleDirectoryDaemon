require 'spec_helper'

describe CreateUserMessageHandler do

  before :all do
    @sender=GorgMessageSender.new(
        host:GoogleDirectoryDaemon.config['rabbitmq_host'],
        port:GoogleDirectoryDaemon.config['rabbitmq_port'],
        user:GoogleDirectoryDaemon.config['rabbitmq_user'],
        pass:GoogleDirectoryDaemon.config['rabbitmq_password'],
        vhost:GoogleDirectoryDaemon.config['rabbitmq_vhost'],
        exchange_name: GoogleDirectoryDaemon.config['rabbitmq_exchange_name']
    )
    @google_directory_daemon = GoogleDirectoryDaemon.new
    @google_directory_daemon.start
  end

  after :all do
    @google_directory_daemon.stop
  end

  describe "#CreateUserMessageHandler" do
    it "create user from input message" do
        @sender.send_message({:id_soce => "66281"},"request.gapps.account.create", verbose: true)
        sleep(1)
        google_api = GoogleDirectoryDaemon.google_api_service
        expect(google_api.data).to eq({"password"=>"MgouPassword", "primaryEmail"=>"johne_doone@poubs.org", "name"=>{"familyName"=>"Dooone", "givenName"=>"Johne"}})
    end
  end
end

