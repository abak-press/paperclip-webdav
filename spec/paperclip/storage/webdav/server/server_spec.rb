require 'spec_helper'

describe Paperclip::Storage::Webdav::Server do

  let(:host) { 'http://st1.static.com' }
  let(:client) { double('Client') }
  let(:server) { described_class.new({url: host}) }

  before do
    allow(client).to receive(:host).and_return(host)
    expect(Net::Webdav::Client).to receive(:new).and_return(client)
  end

  describe '#put_file' do
    it { expect(client).to receive(:put_file).with('/path', '/file') }

    after { server.put_file('/path', '/file') }
  end
end
