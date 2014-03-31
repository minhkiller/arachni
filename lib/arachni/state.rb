=begin
    Copyright 2010-2014 Tasos Laskos <tasos.laskos@gmail.com>
    All rights reserved.
=end

module Arachni

# Stores and provides access to the state of the system.
#
# @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
class State

    # {State} error namespace.
    #
    # All {State} errors inherit from and live under it.
    #
    # @author Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>
    class Error < Arachni::Error
    end

    require_relative 'state/options'
    require_relative 'state/audit'
    require_relative 'state/element_filter'
    require_relative 'state/framework'

class <<self

    # @return     [Options]
    attr_accessor :options

    # @return     [Audit]
    attr_accessor :audit

    # @return     [ElementFilter]
    attr_accessor :element_filter

    # @return     [Framework]
    attr_accessor :framework

    def reset
        @options        = Options.new
        @audit          = Audit.new
        @element_filter = ElementFilter.new
        @framework      = Framework.new
    end

    # @param    [String]    directory
    #   Location of the dump directory.
    # @return   [String]
    #   Location of the directory.
    def dump( directory )
        FileUtils.mkdir_p( directory )

        each do |name, state|
            state.dump( "#{directory}/#{name}/" )
        end

        directory
    end

    # @param    [String]    directory
    #   Location of the dump directory.
    # @return   [State]     `self`
    def load( directory )
        each do |name, state|
            send( "#{name}=", state.class.load( "#{directory}/#{name}/" ) )
        end

        self
    end

    # Clears all states.
    def clear
        each { |_, state| state.clear }
        self
    end

    private

    def each( &block )
        [:options, :audit, :element_filter, :framework].each do |attr|
            block.call attr, send( attr )
        end
    end

end

reset
end
end
