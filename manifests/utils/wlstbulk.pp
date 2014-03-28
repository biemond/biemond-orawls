#  define orawls::utils::wlstbulk
#
#  needs puppet version >= 3.4 , need to set --parser future ( puppet agent )
#
#
#  possible hiera examples ( use hiera_array )
#
# with global parameters and inside with params
#
# jms_module_instances:
#   - clusterOne:
#      global_parameters:
#         log_output:           *logoutput
#         weblogic_type:        "jmsmodule"
#         script:               'createJmsModule.py'
#         params:
#            - "jmsModuleName    = 'jmsClusterModule'"
#      jmsClusterModule:
#         weblogic_object_name: "jmsClusterModule"
#         params:
#            - "target           = 'WebCluster'"
#            - "targetType       = 'Cluster'"
#
# with global parameters
#
# managed_servers_instances:
#   - clusterOne:
#      global_parameters:
#         log_output:           *logoutput
#         weblogic_type:        "server"
#         script:               'createServer.py'
#      wlsServer1_node1:
#         weblogic_object_name: "wlsServer1"
#         params:
#            - "javaArguments    = '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer1.out -Dweblogic.Stderr=/data/logs/wlsServer1_err.out'"
#            - "wlsServerName    = 'wlsServer1'"
#            - "machineName      = 'Node1'"
#            - "listenAddress    = 8001"
#            - "nodeMgrLogDir    = '/data/logs'"
#      wlsServer2_node2:
#         weblogic_object_name: "wlsServer2"
#         params:
#            - "javaArguments    = '-XX:PermSize=256m -XX:MaxPermSize=256m -Xms752m -Xmx752m -Dweblogic.Stdout=/data/logs/wlsServer2.out -Dweblogic.Stderr=/data/logs/wlsServer2_err.out'"
#            - "wlsServerName    = 'wlsServer2'"
#            - "machineName      = 'Node2'"
#            - "listenAddress    = 8001"
#            - "nodeMgrLogDir    = '/data/logs'"
#
# no global parameters
#
# cluster_instances:
#   - clusterOne:
#      cluster_web:
#         weblogic_object_name: "WebCluster"
#         log_output:           *logoutput
#         weblogic_type:        "cluster"
#         script:               'createCluster.py'
#         params:
#            - "clusterName      = 'WebCluster'"
#            - "clusterNodes     = 'wlsServer1,wlsServer2'"
#
# with empty global parameters
#
# jms_servers_instances:
#   - clusterOne:
#      global_parameters:
#      jmsServerNode1:
#         log_output:           *logoutput
#         weblogic_type:        "jmsserver"
#         script:               'createJmsServer.py'
#         weblogic_object_name: "jmsServer1"
#         params:
#            - "target           = 'wlsServer1'"
#            - "jmsServerName    = 'jmsServer1'"
#            - "targetType       = 'Server'"
#      jmsServerNode2:
#         log_output:           *logoutput
#         weblogic_type:        "jmsserver"
#         script:               'createJmsServer.py'
#         weblogic_object_name: "jmsServer2"
#         params:
#            - "target           = 'wlsServer2'"
#            - "jmsServerName    = 'jmsServer2'"
#            - "targetType       = 'Server'"
#
#
#  or inside puppet
#
#   $entries_array =
#    [{  'ClusterOne' => {
#            'global_parameters' =>
#               {
#                log_output     => true,
#                weblogic_type  => "jmsobject",
#                script         => 'createJmsQueueOrTopic.py',
#                params         =>
#                  [  "subDeploymentName = 'jmsServers'",
#                     "jmsModuleName     = 'jmsClusterModule'",
#                     "distributed       = 'true'",
#                     "balancingPolicy   = 'Round-Robin'",
#                     "useRedirect       = 'true'",
#                     "limit             = '3'",
#                     "policy            = 'Redirect'",
#                     "errorObject       = 'ErrorQueue'",
#                  ],
#              } ,
#            'createJmsQueueforJmsModule1' =>
#               {
#                 weblogic_object_name  => "Queue1",
#                 params                =>
#                   [ "jmsType           = 'queue'",
#                     "jmsName           = 'Queue1'",
#                     "jmsJNDIName       = 'jms/Queue1'",
#                   ],
#               } ,
#             'createJmsQueueforJmsModule2' =>
#               {
#                 weblogic_object_name  => "Queue2",
#                 params                =>
#                   [ "jmsType           = 'queue'",
#                     "jmsName           = 'Queue2'",
#                     "jmsJNDIName       = 'jms/Queue2'",
#                   ],
#              },
#        },
#    },
#   ]
#
#
#

define orawls::utils::wlstbulk(
    $entries_array = undef,
){

#uncomment here

#  $entries_array.each |$hieraEntry| {
#   # every hiera entry
#   $hieraEntry.each |$hieraTitle,$hieraEntryValues| {
#     # select global params of the hiera entry
#     # notice $hieraTitle
#     $globals        = $hieraEntryValues.filter |$x| {  $x[0] == 'global_parameters'  }
#     # only select params from global params, will merge later
#     if ( $globals['global_parameters'] != undef ) {
#       $params         = $globals['global_parameters'].filter |$x| {  $x[0] == 'params'  }
#       # remove params from global params, so we will get all the default params
#       $default_params = $globals['global_parameters'].filter |$x| {  $x[0] != 'params'  }
#     } else {
#       # notice "params is null"
#       $params         = {}
#       $default_params = {}
#     }
#     # get all entries except global params
#     $wlstEntries = $hieraEntryValues.filter |$x| {  $x[0] != 'global_parameters'  }
#     # for every create WLST object
#     $wlstEntries.each |$index5,$value5 | {
#        # notice "entry $index5"

#        $entry_other_params = $value5.filter |$x| {  $x[0] != 'params'  }
#        $entry_params = $value5['params']

#        # merge WLST params with global params
#        if $params['params'] == undef {
#          $all_params = $entry_params
#          # notice "no global params"
#        } else {
#          # notice "merge with global params"
#          $all_params = $params['params'] + $entry_params
#        }
#        # notice "all_params $all_params"
#        # notice "default_params $default_params"

#        if ( $default_params == undef ) {
#           $weblogic_object_name = $entry_other_params['weblogic_object_name']
#           $log_output           = $entry_other_params['log_output']
#           $weblogic_type        = $entry_other_params['weblogic_type']
#           $script               = $entry_other_params['script']
#        } else {
#           if ($entry_other_params['weblogic_object_name'] == undef ) {
#             $weblogic_object_name = $default_params['weblogic_object_name']
#           } else {
#             $weblogic_object_name = $entry_other_params['weblogic_object_name']
#           }
#           if ($entry_other_params['log_output'] == undef ) {
#             $log_output = $default_params['log_output']
#           } else {
#             $log_output = $entry_other_params['log_output']
#           }
#           if ($entry_other_params['weblogic_type'] == undef ) {
#             $weblogic_type = $default_params['weblogic_type']
#           } else {
#             $weblogic_type = $entry_other_params['weblogic_type']
#           }
#           if ($entry_other_params['script'] == undef ) {
#             $script = $default_params['script']
#           } else {
#             $script = $entry_other_params['script']
#           }
#        }

#        # create new hash
#        $createEntry = {  "$index5" =>
#                              {
#                                 weblogic_object_name  => $weblogic_object_name,
#                                 log_output            => $log_output,
#                                 weblogic_type         => $weblogic_type,
#                                 script                => $script,
#                                 params                => $all_params ,
#                              }
#                       }
#        # create WLST object , add entry plus default
#        create_resources('orawls::wlstexec',$createEntry, $default_params)
#     }
#  }
# }

# till here
#

}
