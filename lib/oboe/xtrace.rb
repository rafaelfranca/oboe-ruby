# Copyright (c) 2013 AppNeta, Inc.
# All rights reserved.

module Oboe
  module XTrace
    class << self

      ##
      #  Oboe::XTrace.valid?
      #
      #  Perform basic validation on a potential X-Trace ID
      #
      def valid?(xtrace)
        begin
          # Shouldn't be nil
          return false unless xtrace

          # The X-Trace ID shouldn't be an initialized empty ID
          return false if (xtrace =~ /^1b0000000/i) == 0

          # Valid X-Trace IDs have a length of 58 bytes and start with '1b'
          return false unless xtrace.length == 58 and (xtrace =~ /^1b/i) == 0

          true
        rescue StandardError => e
          Oboe.logger.debug e.message
          Oboe.logger.debug e.backtrace
          false
        end
      end

      ##
      # Oboe::XTrace.task_id
      #
      # Extract and return the task_id portion of an X-Trace ID
      #
      def task_id(xtrace)
        begin
          return nil unless Oboe::XTrace.valid?(xtrace)

          xtrace[2..41]
        rescue StandardError => e
          Oboe.logger.debug e.message
          Oboe.logger.debug e.backtrace
          return nil
        end
      end

    end
  end
end

