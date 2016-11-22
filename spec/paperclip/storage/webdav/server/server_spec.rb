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

  context 'when could not connect to server' do
    [:file_exists?, :delete_file].each do |meth|
      it "raise connection error for method #{meth}" do
        allow(client).to receive(meth).and_raise(Curl::Err::ConnectionFailedError)

        expect { server.public_send(meth, '/file') }
          .to raise_error(described_class::ConnectionFailedError, /#{host}/)
      end
    end

    [:put_file, :get_file].each do |meth|
      it "raise connection error for method #{meth}" do
        allow(client).to receive(meth).and_raise(Curl::Err::ConnectionFailedError)

        expect { server.public_send(meth, '/file', '/path') }
          .to raise_error(described_class::ConnectionFailedError, /#{host}/)
      end
    end
  end
end
