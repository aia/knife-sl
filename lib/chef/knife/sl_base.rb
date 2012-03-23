#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Author:: Artem Veremey (<artem@veremey.net>)
# Copyright:: Copyright (c) 2011 Opscode, Inc. 2012 Artem Veremey
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/knife'

class Chef
  class Knife
    module SlBase

      # :nodoc:
      # Would prefer to do this in a rational way, but can't be done b/c of
      # Mixlib::CLI's design :(
      def self.included(includer)
        includer.class_eval do

          deps do
            require 'softlayer_api'
            require 'readline'
            require 'chef/json_compat'
          end

          option :sl_api_username,
            :short => "-A ID",
            :long => "--sl_api_username USERNAME",
            :description => "Your SoftLayer Username",
            :proc => Proc.new { |key| Chef::Config[:knife][:sl_api_username] = key }

          option :sl_api_key,
            :short => "-K KEY",
            :long => "--sl_api_key KEY",
            :description => "Your SoftLayer API Key",
            :proc => Proc.new { |key| Chef::Config[:knife][:sl_api_key] = key }
            
          option :sl_domain,
            :short => "-D DOMAIN",
            :long => "--domain DOMAIN",
            :description => "Your SoftLayer Domain",
            :proc => Proc.new { |key| Chef::Config[:knife][:sl_domain] = key }

        end
      end

      def connection(sl_service = "SoftLayer_Account")
        @connection = SoftLayer::Service.new(
          sl_service,
          :username => locate_config_value(:sl_api_username),
          :api_key => locate_config_value(:sl_api_key)
        )
      end
      
      def locate_config_value(key)
        key = key.to_sym
        set_key = ["set_", key].join.to_sym
        
        ret = Chef::Config[:knife][set_key].nil? ? Chef::Config[:knife][key] : Chef::Config[:knife][set_key]
        ret = ret.nil? ? config[key] : ret
        
        if (ret.nil?)
          ui.error("Required configuration variable not set: #{key}")
          exit 1
        end
        
        return ret
      end
      
      def current_domain
        Chef::Config[:knife][:sl_domain]
      end
      
      def list_vlans
        object_mask = {
          "networkVlans" => ""
        }
        
        vlans = connection.object_mask(object_mask).getNetworkVlans
        
        return vlans
      end
      
      
    end
  end
end


