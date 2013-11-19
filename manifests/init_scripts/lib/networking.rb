# We know there should be exactly three interfaces
# The vagrant interface is the 3rd, as we set it up as such
# The box shouldn't be up otherwise.
require 'rubygems'
require 'ohai'

module Networking
  def self.getIp(ifaceCount=2)
    o = Ohai::System.new()
    o.all_plugins
    lastIp = '0.0.0.0' # default all devices

    # And retrieve some useful semantic reference attributes for network interfaces
    o['network']['interfaces'].each do |iface, addrs|
      addrs['addresses'].each do |ip, params|
        o["ipaddress_#{iface}"] ||= ip if params['family'].eql?('inet')
        o["ipaddress6_#{iface}"] ||= ip if params['family'].eql?('inet6')
        o["macaddress_#{iface}"] ||= ip if params['family'].eql?('lladdr')
        lastIp = o["ipaddress_#{iface}"]
      end
    end

    lastIp
  end
end

puts Networking.getIp
