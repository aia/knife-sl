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
    class SlFirewallList < Knife

      include Knife::SlBase

      banner "knife sl firewall list (options)"
      
      def run
        $stdout.sync = true
        
        firewalls = list_firewalls
        
        firewalls.each do |firewall|
          firewall['firewallInterfaces'].each do |fw_interface|
            puts "Interface: #{fw_interface['name']}"
            rules = list_firewall_rules_by_id(fw_interface['id'])
            format_rules(rules)
          end
        end
      end
      
      def list_firewall_rules_by_id(id)
        mask = {
          "rules" => ""
        }
        
        host_ref = connection("SoftLayer_Network_Firewall_Interface").object_with_id(id)
        
        host_objs = host_ref.object_mask(mask).getFirewallContextAccessControlLists.find_all.to_a
        
        return host_objs
      end
      
      def format_rules(rules)
        
        if rules == []
          puts "Empty"
          
          return
        end
        
        rule_list = ["Order", "ID", "Action", "Proto", "SRC IP", "SRC Mask", "DST IP", "DST Mask", "DST Ports", "Notes"]
        
        rule_list.map!{ |f| ui.color(f, :bold) }
        
        rules = rules.first['rules'].sort_by { |rule| rule['orderValue'] }
        
        rules.each do |rule|
          rule_list << rule['orderValue'].to_s
          rule_list << rule['id'].to_s
          rule_list << rule['action'].to_s
          rule_list << rule['protocol'].to_s
          rule_list << rule['sourceIpAddress'].to_s
          rule_list << rule['sourceIpSubnetMask'].to_s
          rule_list << rule['destinationIpAddress'].to_s
          rule_list << rule['destinationIpSubnetMask']
          rule_list << [rule['destinationPortRangeStart'].to_s, rule['destinationPortRangeEnd'].to_s].join("-")
          rule_list << rule['notes'].to_s
        end
        
        puts ui.list(rule_list, :uneven_columns_across, 10)
      end
    end
  end
end

