require_relative '../radiusion'

module Radiusion
  class Dictionary
    def self.find_by_name(name)
      dict = {
        'User-Name' => [1, 'string'],
        'User-Password' => [2, 'string'],
        'NAS-IP-Address' => [4, 'ipaddr'],
        'NAS-Port' => [5, 'integer']
      }
      dict[name]
    end

    def self.find_by_code
      dict = {
        1 => ['User-Name', 'string'],
        2 => ['User-Password', 'string'],
        4 => ['NAS-IP-Address', 'ipaddr'],
        5 => ['NAS-Port', 'integer']
      }
    end
  end
end
