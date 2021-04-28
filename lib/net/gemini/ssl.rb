# frozen_string_literal: true

module Gemini
  # Contains specific method to handle SSL connection
  module SSL
    private

    def ssl_check_existing(new_cert, cert_file)
      raw = File.read cert_file
      saved_one = OpenSSL::X509::Certificate.new raw
      return true if saved_one == new_cert
      # TODO: offer some kind of recuperation
      warn "#{cert_file} does not match the current host cert!"
      false
    end

    def ssl_verify_cb(cert)
      return false unless OpenSSL::SSL.verify_certificate_identity(cert, @host)
      cert_file = File.expand_path("#{@certs_path}/#{@host}.pem")
      return ssl_check_existing(cert, cert_file) if File.exist?(cert_file)
      FileUtils.mkdir_p(File.expand_path(@certs_path))
      File.open(cert_file, 'wb') { |f| f.print cert.to_pem }
      true
    end

    def ssl_context
      ssl_context = OpenSSL::SSL::SSLContext.new
      ssl_context.set_params(verify_mode: OpenSSL::SSL::VERIFY_PEER)
      ssl_context.min_version = OpenSSL::SSL::TLS1_2_VERSION
      ssl_context.verify_hostname = true
      ssl_context.ca_file = '/etc/ssl/certs/ca-certificates.crt'
      ssl_context.verify_callback = lambda do |preverify_ok, store_context|
        return true if preverify_ok
        ssl_verify_cb store_context.current_cert
      end
      ssl_context
    end

    def init_sockets
      socket = TCPSocket.new(@host, @port)
      @ssl_socket = OpenSSL::SSL::SSLSocket.new(socket, ssl_context)
      # Close underlying TCP socket with SSL socket
      @ssl_socket.sync_close = true
      @ssl_socket.hostname = @host # SNI
      @ssl_socket.connect
    end

    # Closes the SSL and TCP connections.
    def finish
      @ssl_socket.close
    end
  end
end
