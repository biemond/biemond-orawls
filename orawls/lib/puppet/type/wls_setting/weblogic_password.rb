newproperty(:weblogic_password) do
  include EasyType

  desc 'weblogic password'

  to_translate_to_resource do |raw_resource|
    raw_resource[self.name]
  end

  def change_to_s(currentvalue, newvalue)
    if currentvalue == :absent
      "created password"
    else
      "changed password"
    end
  end

  def is_to_s(currentvalue)
    '[old password redacted]'
  end

  def should_to_s(newvalue)
    '[new password redacted]'
  end
end
