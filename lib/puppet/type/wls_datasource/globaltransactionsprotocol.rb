newproperty(:globaltransactionsprotocol) do
  include EasyType

  desc 'The global Transactions Protocol'
  newvalues('TwoPhaseCommit', 'EmulateTwoPhaseCommit', 'OnePhaseCommit', 'LoggingLastResource', 'None')
  defaultto 'TwoPhaseCommit'

  to_translate_to_resource do |raw_resource|
    raw_resource['globaltransactionsprotocol']
  end

end
