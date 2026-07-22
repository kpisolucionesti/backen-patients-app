class AccessPolicy < ApplicationRecord
  def ip_allowed?(remote_ip)
    return true unless ip_restriction_enabled?
    return false if allowed_ips.blank?

    allowed_ips.split(",").any? do |cidr|
      IPAddr.new(cidr.strip).include?(remote_ip)
    end
  rescue IPAddr::InvalidAddressError
    false
  end
end
