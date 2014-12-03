require 'spec_helper'

describe Paperclip::Storage::Webdav::Server do
  let(:client) { double('Client') }

  describe '#put_file' do
    let(:server) { described_class.new({}) }

    before { expect(Net::Webdav::Client).to receive(:new).and_return(client) }

    it { expect(client).to receive(:put_file).with('/path', '/file', true) }

    after { server.put_file('/path', '/file') }
  end
end
