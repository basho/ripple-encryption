module Ripple
  module Encryption
    class Migration
      # create log files in the tmp dir
      def initialize
        relative_root = File.expand_path(File.join('..','..','..'),__FILE__)
        require File.join(relative_root,'lib','ripple-encryption.rb')
        tmp_dir = File.join(relative_root,'tmp')
        output_dir = File.join(tmp_dir,Time.now.strftime("%m-%d-%Y-%I%M%p"))
        Dir.mkdir(tmp_dir) unless File.exists?(tmp_dir)
        Dir.mkdir(output_dir) unless File.exists?(output_dir)
        @fetched_file = File.open(File.join(output_dir,'fetched.log'),'w')
        @stored_file  = File.open(File.join(output_dir,'stored.log'),'w')
        @error_file   = File.open(File.join(output_dir,'error.log'),'w')
      end

      # finde only the encryptable models
      def models
        Objects.constants.map{|c| "#{c}".constantize}.select{|c| c.include?(Ripple::Encryption)}
      end

      # cycle through all objects and save them
      def convert(type)
        # the difference between encryption or decryption is
        # simply changing the content-type of the object so
        # that ripple knows what way to serialize it
        case type
        when :encrypt
          content_type = 'application/x-json-encrypted'
        when :decrypt
          content_type = 'application/json'
        end

        # we don't need no stinking warnings :-)
        Riak.disable_list_keys_warnings = true

        # cycle through each key in the database and
        # read it, then save it
        print 'Processing buckets: '
        models.each do |model|
          success = nil
          count = 0
          bucket_name = model.bucket_name
          model.bucket.keys do |streaming_keys|
            streaming_keys.each do |key|
              begin
                object = model.find key
                log :fetched, "/buckets/#{bucket_name}/keys/#{key}"
                object.robject.content_type = content_type
                object.save!
                log :stored, "/buckets/#{bucket_name}/keys/#{key}"
                count += 1
              rescue => e
                log :error, "/buckets/#{bucket_name}/keys/#{key} #{e}".force_encoding('UTF-8')
                success = 'E, '
              end
            end
          end
          print success || "#{count}, "
        end
        puts ' Done.'

        # warn us. please. :-)
        Riak.disable_list_keys_warnings = false
      end

      # log the object action
      def log(type, object, error=nil)
        case type
        when :fetched
          @fetched_file.puts object
        when :stored
          @stored_file.puts object
        when :error
          @error_file.write object
          @error_file.write error
          @error_file.write "\n"
        end
      end
    end
  end
end
