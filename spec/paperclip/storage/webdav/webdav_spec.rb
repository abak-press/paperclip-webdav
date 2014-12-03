require 'spec_helper'

describe Paperclip::Storage::Webdav do
  let(:original_path) { '/files/original/image.png' }
  let(:thumb_path) { '/files/thumb/image.png' }
  let(:model) { double('Model', id: 1, image_file_name: 'image.png') }
  let(:base_options) do
    {
      storage: :webdav,
      path: '/files/:style/:filename',
      webdav_servers: [
        {url: 'http://webdav1.example.com'},
        {url: 'http://webdav2.example.com'}
      ]
    }
  end

  let(:attachment) do
    attachment = Paperclip::Attachment.new(:image, model, base_options)
    attachment.instance_variable_set(:@original_path, original_path)
    attachment.instance_variable_set(:@thumb_path, thumb_path)
    attachment
  end

  let(:attachment_with_public_url) do
    attachment = Paperclip::Attachment.new(:image, model, base_options.merge(public_url: 'http://public.example.com'))
    attachment.instance_variable_set(:@original_path, original_path)
    attachment.instance_variable_set(:@thumb_path, thumb_path)
    attachment
  end

  describe '#public_url' do
    context 'when attachment_without_public_url' do
      it do
        expect(attachment.public_url(:original)).
          to eq 'http://webdav1.example.com/files/original/image.png'
      end

      it do
        expect(attachment.public_url(:thumb)).
          to eq 'http://webdav1.example.com/files/thumb/image.png'
      end
    end

    context 'when attachment_with_public_url' do
      it do
        expect(attachment_with_public_url.public_url(:original)).
          to eq 'http://public.example.com/files/original/image.png'
      end

      it do
        expect(attachment_with_public_url.public_url(:thumb)).
          to eq 'http://public.example.com/files/thumb/image.png'
      end
    end
  end

  describe 'exists?' do
    it 'should returns false if original_name not set' do
      allow(attachment).to receive(:original_filename).and_return(nil)
      expect(attachment.exists?).to be_falsy
    end

    it 'should returns true if file exists on the primary server' do
      expect(attachment.primary_server).
        to receive(:file_exists?).with(attachment.instance_variable_get(:@original_path)).and_return(true)

      expect(attachment.exists?).to be_truthy
    end

    it 'accepts an optional style_name parameter to build the correct file pat' do
      expect(attachment.primary_server).
        to receive(:file_exists?).with(attachment.instance_variable_get(:@thumb_path)).and_return(true)

      expect(attachment.exists?(:thumb)).to be_truthy
    end
  end

  describe 'flush_writes' do
    it 'store all files on each server' do
      attachment.instance_variable_set(:@queued_for_write, {
        :original => double('file'),
        :thumb    => double('file')
      })

      queued_for_write = attachment.instance_variable_get(:@queued_for_write)

      queued_for_write.each do |_, v|
        expect(v).to receive(:rewind)
      end

      attachment.servers.each do |server|
        expect(server).
          to receive(:put_file).with(attachment.instance_variable_get(:@original_path), queued_for_write[:original])

        expect(server).
          to receive(:put_file).with(attachment.instance_variable_get(:@thumb_path), queued_for_write[:thumb])
      end

      expect(attachment).to receive(:after_flush_writes).with(no_args)
      attachment.flush_writes
      expect(attachment.queued_for_write).to be_empty
    end
  end

  describe 'flush_deletes' do
    it 'deletes files on each servers' do
      queued_for_delete = [original_path, thumb_path]

      attachment.instance_variable_set(:@queued_for_delete, queued_for_delete)

      attachment.servers.each do |server|
        queued_for_delete.each do |path|
          expect(server).to receive(:delete_file).with(path)
        end
      end

      attachment.flush_deletes
      expect(attachment.instance_variable_get(:@queued_for_delete)).to be_empty
    end
  end

  describe 'copy_to_local_file' do
    it 'save file' do
      expect(attachment.primary_server).
        to receive(:get_file).with(attachment.instance_variable_get(:@original_path), '/local').and_return(nil)

      attachment.copy_to_local_file(:original, '/local')
    end

    it 'save file with custom style' do
      expect(attachment.primary_server).
        to receive(:get_file).with(attachment.instance_variable_get(:@thumb_path), '/local').and_return(nil)

      attachment.copy_to_local_file(:thumb, '/local')
    end
  end
end
