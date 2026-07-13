# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Zerocracy
# SPDX-License-Identifier: MIT

# Shared validation methods for BazaRb and BazaRb::Fake.
#
# Every method here raises RuntimeError on invalid input.
# By using the same module in both real and fake implementations, we
# guarantee they reject the same set of invalid inputs.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class BazaRb
  # Validation helpers.
  module Validation
    # Validate a product/job/durable name (pname).
    #
    # @param [String, nil] name The name to validate
    # @param [String] context Human-readable field name for error messages
    # @raise [RuntimeError] If validation fails
    def valname(name, context: 'name')
      raise(RuntimeError, "The \"#{context}\" is nil") if name.nil?
      raise(RuntimeError, "The \"#{context}\" may not be empty") if name.empty?
      raise(RuntimeError, "The #{context} #{name.inspect} is not valid") unless name.match?(/\A[a-z0-9-]+\z/)
      raise(RuntimeError, "The #{context} #{name.inspect} is too long") if name.length > 32
    end

    # Validate a job/durable ID.
    #
    # @param [Integer, nil] id The ID to validate
    # @raise [RuntimeError] If validation fails
    def valid(id)
      raise(RuntimeError, 'The ID of the job is nil') if id.nil?
      raise(RuntimeError, 'The ID of the job must be an Integer') unless id.is_a?(Integer)
      raise(RuntimeError, 'The ID of the job must be a positive integer') unless id.positive?
    end

    # Validate a file path.
    #
    # @param [String, nil] file The file path to validate
    # @param [Boolean] must_exist Whether to check that the file exists on disk
    # @param [String] context Human-readable field name for error messages
    # @raise [RuntimeError] If validation fails
    def valfile(file, must_exist: false, context: 'file')
      raise(RuntimeError, "The \"#{context}\" is nil") if file.nil?
      raise(RuntimeError, "The \"#{context}\" may not be empty") if file.empty?
      raise(RuntimeError, "The file '#{file}' is absent") if must_exist && !File.exist?(file)
    end

    # Validate an owner string.
    #
    # @param [String, nil] owner The owner to validate
    # @param [String] context Human-readable field name for error messages
    # @raise [RuntimeError] If validation fails
    def valowner(owner, context: 'owner')
      raise(RuntimeError, "The \"#{context}\" of the lock is nil") if owner.nil?
      raise(RuntimeError, "The \"#{context}\" of the lock may not be empty") if owner.empty?
      raise(RuntimeError, "The #{context} #{owner.inspect} is not valid") unless owner.match?(/\A.+\z/)
    end
  end
end
