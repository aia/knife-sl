#
# Author:: Artem Veremey (<artem@veremey.net>)
# Copyright:: Copyright (c) 2012 Artem Veremey
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

require 'chef/knife/sl_base'
require 'active_support/inflector'

class Chef
  class Knife
    class SlServerList < Knife

      include Knife::SlBase

      banner "knife sl server list (options)"
      
      def run
        $stdout.sync = true
        
        server_list = list_servers(current_domain)

        puts ui.list(server_list, :uneven_columns_across, 6)
      end
      
      def list_servers(domain = nil)
        server_list = ["ID", "Name", "Public IP", "Private IP", "Management IP", "Notes"]
        
        server_list.map!{ |f| ui.color(f, :bold) }
        
        case config[:hourly] 
          when true
            puts "Listing hourly instances"
            type = connection.getHourlyVirtualGuests
        else
            puts "Listing instances"
            type = connection.getHardware
        end

        type.find_all.each do |server|
          next if domain && server['domain'] != domain
          server_list << server['id'].to_s
          server_list << server['fullyQualifiedDomainName'].to_s
          server_list << server['primaryIpAddress'].to_s
          server_list << server['primaryBackendIpAddress'].to_s
          server_list << server['networkManagementIpAddress'].to_s
          server_list << server['notes'].to_s
        end
        
        return server_list
      end
    end
  end
end

