module Puppet::Parser::Functions
  newfunction(:hash2xml, :type => :rvalue) do |args|

    if args.length < 2
      raise(Puppet::ParseError, "hash2xml(): Wrong number of arguments "+
        "given #{args.length} for 2.")
    end

    refname = args[0]
    ref = args[1]
    ind = args.length > 2 ? args[2] : ""

    str = String.new

    if ref.is_a?(Array)
      ref.each do |elem|
        str.concat function_hash2xml([refname, elem, ind])
      end
    elsif ref.is_a?(Hash)
      str.concat "#{ind}<#{refname}>\n"
      ref.each do |subkey, elem|
        str.concat function_hash2xml([subkey, elem, "#{ind}  "])
      end
      str.concat "#{ind}</#{refname}>\n"
    elsif ref.nil?
      str.concat "#{ind}<#{refname}></#{refname}>\n"
    else
      str.concat "#{ind}<#{refname}>#{ref}</#{refname}>\n"
    end

    return str
  end
end
