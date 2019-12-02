class Hash
  def deep_stringify_keys
    Hash.new.tap do |h|
      each do |k, v|
        h[k.to_s] = v.is_a?(Hash) ? v.deep_stringify_keys : v
      end
    end
  end
end
