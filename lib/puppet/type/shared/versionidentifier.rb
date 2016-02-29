newproperty(:versionidentifier) do
  include EasyType

  desc 'The version identifier'

  defaultto {
    version_in_ear
  }


  to_translate_to_resource do | raw_resource|
    raw_resource['versionidentifier']
  end

  private

  def version_in_ear
    begin
      open("| unzip -p #{resource[:localpath]} META-INF/MANIFEST.MF | grep WebLogic-Application-Version:").read.split(':')[1].strip
    rescue
      nil
    end
  end

end

