require_relative '../radiusion'

module Radiusion
  class Dictionary
    def self.find(name)
      dict = {
        'User-Name' => [1, 'string'],
        'User-Password' => [2, 'string'],
        'NAS-IP-Address' => [4, 'ipaddr'],
        'NAS-Port' => [5, 'integer']
      }
      dict[name]
    end
  end
end
