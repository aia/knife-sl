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
          :username => Chef::Config[:knife][:sl_api_username],
          :api_key => Chef::Config[:knife][:sl_api_key]
        )
      end
      
      def current_domain
        Chef::Config[:knife][:sl_domain]
      end
    end
  end
end


