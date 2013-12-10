module Paperclip
  class AbstractAdapter
    def stat
      File.stat(@tempfile)
    end
  end
end
